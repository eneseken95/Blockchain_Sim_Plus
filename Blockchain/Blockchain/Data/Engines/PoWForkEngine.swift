//
//  PoWForkEngine.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

import Foundation

final class PoWForkEngine: Forkable {
    struct Node { let block: Block; let parent: String?; let height: Int }
    private var nodes: [String: Node] = [:]
    private var best: Node!
    private let difficulty: Int

    init(difficulty: Int) {
        self.difficulty = difficulty
        let g = Block.genesis(difficulty: difficulty)
        let n = Node(block: g, parent: nil, height: 0)
        nodes[g.hash] = n; best = n
    }

    private func mineOn(parent: String, data: String) -> Node {
        var b = Block(index: (nodes[parent]?.height ?? -1) + 1, prevHash: parent, timestamp: Date().timeIntervalSince1970, data: data, difficulty: difficulty, nonce: 0)
        while !b.isValidPoW() { b.nonce &+= 1 }
        let n = Node(block: b, parent: parent, height: (nodes[parent]?.height ?? -1) + 1)
        nodes[b.hash] = n; if n.height >= best.height { best = n }
        return n
    }

    private func tips() -> [Node] {
        let parentSet = Set(nodes.values.compactMap { $0.parent })
        return nodes.values.filter { !parentSet.contains($0.block.hash) }
    }

    func simulateForks(miners: Int, rounds: Int, forkProb: Double) -> (logs: [String], metrics: [String: String], samples: [MetricSample]) {
        var logs: [String] = []; var samples: [MetricSample] = []
        for r in 0 ..< rounds {
            let ts = tips()
            for m in 0 ..< miners {
                let parent = (Double.random(in: 0 ... 1) < forkProb && !ts.isEmpty ? ts.randomElement()!.block.hash : best.block.hash)
                let n = mineOn(parent: parent, data: "r=\(r),M=\(m)")
                logs.append("[FORK] r=\(r) M=\(m) parent=\(parent.prefix(8)) new=\(n.block.hash.prefix(12)) best=\(best.block.hash.prefix(12)) h=\(best.height)")
            }
            samples.append(MetricSample(series: "fork_height", x: Double(r), y: Double(best.height)))
        }
        let metrics = ["bestHeight": "\(best.height)", "nodes": "\(nodes.count)"]
        return (logs, metrics, samples)
    }
}
