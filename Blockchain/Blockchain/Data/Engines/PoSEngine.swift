//
//  PoSEngine.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

import Foundation

final class PoSEngine: ConsensusEngine {
    let name = "Proof of Stake"
    private let store: ChainStore
    private let logger: Logger
    private let rng: RandomProvider

    init(store: ChainStore, logger: Logger, rng: RandomProvider) {
        self.store = store; self.logger = logger; self.rng = rng
    }

    func reset() {
        store.reset(genesis: Block.genesis(difficulty: 0))
    }

    func run(parameters: [String: Any]) -> ConsensusResult {
        let vCount = parameters["validators"] as? Int ?? 5
        let epochs = parameters["epochs"] as? Int ?? 2
        let slots = parameters["slotsPerEpoch"] as? Int ?? 10
        let offP = parameters["offlineProb"] as? Double ?? 0.1
        let eqP = parameters["equivProb"] as? Double ?? 0.05
        let slash = parameters["slash"] as? Int ?? 1

        var vals = (0 ..< vCount).map {
            Validator(vid: "V\($0)", stake: rng.int(in: 5 ... 25))
        }
        store.reset(genesis: Block.genesis(difficulty: 0))

        var logs: [String] = []; var produced = 0; var samples: [MetricSample] = []

        for e in 0 ..< epochs {
            for s in 0 ..< slots {
                let w = vals.map { $0.stake }
                guard let idx = rng.weightedIndex(weights: w) else {
                    logs.append("[PoS] no active validators"); break
                }
                if rng.double() < offP {
                    vals[idx].stake = max(0, vals[idx].stake - slash)
                    logs.append("[PoS] e=\(e) s=\(s) \(vals[idx].vid) OFFLINE → slash -\(slash) stake=\(vals[idx].stake)")
                    continue
                }
                let data = "epoch=\(e),slot=\(s),prop=\(vals[idx].vid),stake=\(vals[idx].stake)"
                let b = Block(index: store.all().count, prevHash: store.tip().hash, timestamp: Date().timeIntervalSince1970, data: data, difficulty: 0, nonce: 0)
                store.append(b); produced += 1
                logs.append("[PoS] e=\(e) s=\(s) prop=\(vals[idx].vid) blk=\(b.hash.prefix(12))…")
                samples.append(MetricSample(series: "pos_slots_\(vals[idx].vid)", x: Double(e * slots + s), y: 1))
                if rng.double() < eqP && vals[idx].stake > 0 {
                    vals[idx].stake = max(0, vals[idx].stake - slash)
                    logs.append("[PoS] EQUIVOCATION by \(vals[idx].vid) → slash -\(slash) stake=\(vals[idx].stake)")
                }
            }
        }
        let metrics = ["validators": "\(vCount)", "epochs": "\(epochs)", "slots/epoch": "\(slots)", "produced": "\(produced)", "height": "\(store.all().count - 1)"]
        return ConsensusResult(logs: logs, metrics: metrics, samples: samples)
    }
}
