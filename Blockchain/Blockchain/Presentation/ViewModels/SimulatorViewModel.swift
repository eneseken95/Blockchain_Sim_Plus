//
//  SimulatorViewModel.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 1.11.2025.
//

import Foundation

@MainActor
final class SimulatorViewModel: ObservableObject {
    @Published var mode: Mode = .pow
    @Published var logs: [String] = []
    @Published var metrics: [String: String] = [:]
    @Published var samples: [MetricSample] = []

    @Published var isRunning: Bool = false
    @Published var progress: Double = 0.0
    @Published var progressLabel: String = ""
    @Published var stepLogs: [String] = []
    @Published var cancelRequested: Bool = false

    @Published var difficulty: Int = 3
    @Published var blocks: Int = 6

    @Published var validators: Int = 5
    @Published var epochs: Int = 2
    @Published var slotsPerEpoch: Int = 10
    @Published var offlineProb: Double = 0.1
    @Published var equivProb: Double = 0.05
    @Published var slash: Int = 1

    @Published var enableForkSim: Bool = true
    @Published var forkMiners: Int = 3
    @Published var forkRounds: Int = 8
    @Published var forkProb: Double = 0.35

    private var engine: ConsensusEngine = AppContainer.shared.makePoW()

    func switchEngine() {
        engine = (mode == .pow) ? AppContainer.shared.makePoW() : AppContainer.shared.makePoS()
    }

    private func resetProgress(total: Int, label: String) {
        isRunning = true
        cancelRequested = false
        progress = 0
        progressLabel = label
        stepLogs.removeAll()
        logs.removeAll()
        samples.removeAll()
        metrics.removeAll()
    }

    private func tickProgress(done: Int, total: Int, step: String) {
        progress = total > 0 ? Double(done) / Double(total) : 0
        progressLabel = String(format: "%.0f%%", progress * 100)
        stepLogs.append(step)
        if stepLogs.count > 6 {
            stepLogs.removeFirst(stepLogs.count - 6)
        }
    }

    func run() async {
        switchEngine()
        engine.reset()

        if mode == .pow {
            let totalUnits = blocks + (enableForkSim ? forkRounds : 0)
            resetProgress(total: totalUnits, label: "Starting PoW…")

            let powRes = await runPoWBlocks(totalUnits: totalUnits)

            var aggLogs = powRes.logs
            var aggMetrics = powRes.metrics
            var aggSamples = powRes.samples

            if enableForkSim {
                let forkRes = await runForkRounds(startDone: blocks, totalUnits: totalUnits)
                aggLogs += forkRes.logs
                aggSamples += forkRes.samples
                aggMetrics.merge(forkRes.metrics, uniquingKeysWith: { _, new in new })
            }

            publish(ConsensusResult(logs: aggLogs, metrics: aggMetrics, samples: aggSamples))
            isRunning = false
        } else {
            let totalUnits = max(1, epochs * slotsPerEpoch)
            resetProgress(total: totalUnits, label: "Starting PoS…")

            let out = engine.run(parameters: [
                "validators": validators,
                "epochs": epochs,
                "slotsPerEpoch": slotsPerEpoch,
                "offlineProb": offlineProb,
                "equivProb": equivProb,
                "slash": slash,
            ])

            var count = 0
            for s in out.samples {
                count += 1
                tickProgress(done: min(count, totalUnits), total: totalUnits, step: "Slot \(Int(s.x) + 1)")
                await Task.yield()
                if cancelRequested { break }
            }

            publish(out)
            isRunning = false
        }
    }

    private func publish(_ r: ConsensusResult) {
        logs = r.logs
        metrics = r.metrics
        samples = r.samples
    }

    private func runPoWBlocks(totalUnits: Int) async -> ConsensusResult {
        let localStore = InMemoryChainStore()
        localStore.reset(genesis: Block.genesis(difficulty: difficulty))

        var outLogs: [String] = []
        var outSamples: [MetricSample] = []
        let start = Date()

        for i in 0 ..< blocks {
            if cancelRequested { break }

            var b = Block(index: localStore.all().count,
                          prevHash: localStore.tip().hash,
                          timestamp: Date().timeIntervalSince1970,
                          data: "block-\(i)",
                          difficulty: difficulty,
                          nonce: 0)

            stepLogs.append("Mining block \(i + 1)/\(blocks) (difficulty \(difficulty))")

            let t0 = Date()
            while !b.isValidPoW() {
                b.nonce &+= 1
            }
            if let sig = try? AppContainer.shared.signer.sign(b.headerData) {
                b.signature = sig
                b.publicKey = AppContainer.shared.signer.publicKeyBytes()
            }

            localStore.append(b)
            let dt = Date().timeIntervalSince(t0)
            let dtStr = String(format: "%.2f", dt)
            let line = "[PoW] mined idx=\(b.index) nonce=\(b.nonce) time=\(dtStr)s hash=\(b.hash.prefix(12))…"
            outLogs.append(line)
            outSamples.append(MetricSample(series: "pow_time", x: Double(i), y: dt))

            tickProgress(done: i + 1, total: totalUnits, step: "Block \(i + 1) done")
            await Task.yield()
        }

        let total = Date().timeIntervalSince(start)
        let outMetrics = [
            "difficulty": "\(difficulty)",
            "blocks": "\(blocks)",
            "height": "\(localStore.all().count - 1)",
            "elapsed": String(format: "%.2fs", total),
        ]
        return ConsensusResult(logs: outLogs, metrics: outMetrics, samples: outSamples)
    }

    private func runForkRounds(startDone: Int, totalUnits: Int) async -> (logs: [String], metrics: [String: String], samples: [MetricSample]) {
        var logs: [String] = []
        var samples: [MetricSample] = []

        let fork = AppContainer.shared.makePoWFork(difficulty: difficulty)
        var done = startDone

        for r in 0 ..< forkRounds {
            if cancelRequested { break }
            stepLogs.append("Fork round \(r + 1)/\(forkRounds)")

            let res = fork.simulateForks(miners: forkMiners, rounds: 1, forkProb: forkProb)
            logs += res.logs
            samples += res.samples

            done += 1
            tickProgress(done: done, total: totalUnits, step: "Round \(r + 1) done")
            await Task.yield()
        }

        let metrics = [
            "bestHeight": (samples.last.map { Int($0.y) } ?? 0).description,
            "nodes": "\(logs.filter { $0.hasPrefix("[FORK]") }.count)",
        ]
        return (logs, metrics, samples)
    }
}
