//
//  InMemoryChainStore.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

final class InMemoryChainStore: ChainStore {
    private var blocks: [Block] = []

    func reset(genesis: Block) {
        blocks = [genesis]
    }

    func tip() -> Block {
        blocks.last!
    }

    func append(_ block: Block) {
        blocks.append(block)
    }

    func all() -> [Block] {
        blocks
    }
}
