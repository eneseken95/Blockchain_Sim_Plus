//
//  ChainStore.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

public protocol ChainStore {
    func reset(genesis: Block); func tip() -> Block
    func append(_ block: Block); func all() -> [Block]
}
