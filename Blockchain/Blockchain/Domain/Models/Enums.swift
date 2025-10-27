//
//  Enums.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

enum Mode: String, CaseIterable, Identifiable {
    case pow = "PoW", pos = "PoS"; var id: String { rawValue }
}
