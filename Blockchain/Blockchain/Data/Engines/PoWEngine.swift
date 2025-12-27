//
//  PoWEngine.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

import Foundation

final class PoWEngine: ConsensusEngine {
    let name = "Proof of Work"
    private let store: ChainStore
    private let logger: Logger
    private let signer: Signer

    init(store: ChainStore, logger: Logger, signer: Signer) {
        self.store = store; self.logger = logger; self.signer = signer
    }

    func reset() {
        store.reset(genesis: Block.genesis(difficulty: 1))
    }

    func run(parameters: [String: Any]) -> ConsensusResult {
        let difficulty = parameters["difficulty"] as? Int ?? 3
        let blocks = parameters["blocks"] as? Int ?? 5
        store.reset(genesis: Block.genesis(difficulty: difficulty))

        var logs: [String] = []; var samples: [MetricSample] = []
        let start = Date()
        for i in 0 ..< blocks {
            // 1. Create a candidate block with nonce = 0
            var b = Block(index: store.all().count, prevHash: store.tip().hash, timestamp: Date().timeIntervalSince1970, data: "block-\(i)", difficulty: difficulty, nonce: 0)
            let t0 = Date()
            
            // 2. Mining Loop: Increment nonce until the hash starts with enough zeros
            // This is the "Work" in Proof of Work. It requires CPU power.
            while !b.isValidPoW() { b.nonce &+= 1 }
            
            // 3. Optional: Sign the block if keys are available
            if let sig = try? signer.sign(b.headerData) {
                b.signature = sig
                b.publicKey = signer.publicKeyBytes()

                if let pub = b.publicKey, !signer.verify(b.headerData, signature: sig, publicKey: pub) {
                    logger.log("[WARN] signature verify FAILED for idx=\(b.index)")
                } else {
                    logger.log("[SIG] verified idx=\(b.index)")
                }
            }
            
            // 4. Add the valid block to the chain
            store.append(b)
            let dt = Date().timeIntervalSince(t0)
            let line = "[PoW] mined idx=\(b.index) nonce=\(b.nonce) time=\(String(format: "%.2f", dt))s hash=\(b.hash.prefix(12))…"
            logs.append(line); logger.log(line)
            samples.append(MetricSample(series: "pow_time", x: Double(i), y: dt))
        }
        let total = Date().timeIntervalSince(start)
        let metrics = ["difficulty": "\(difficulty)", "blocks": "\(blocks)", "height": "\(store.all().count - 1)", "elapsed": String(format: "%.2fs", total)]
        return ConsensusResult(logs: logs, metrics: metrics, samples: samples)
    }
}
