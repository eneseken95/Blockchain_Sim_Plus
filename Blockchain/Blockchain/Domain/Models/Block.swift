//
//  Block.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

import CryptoKit
import Foundation

public struct Block: Identifiable, Codable {
    public var id: String { hash }
    let index: Int
    let prevHash: String
    let timestamp: TimeInterval
    var data: String
    var difficulty: Int
    var nonce: UInt64
    var signature: Data? = nil
    var publicKey: Data? = nil

    var header: String {
        "\(index)|\(prevHash)|\(String(format: "%.3f", timestamp))|\(data)|\(nonce)|\(difficulty)"
    }

    var headerData: Data {
        Data(header.utf8)
    }

    var hash: String {
        let digest = SHA256.hash(data: headerData)
        return digest.map {
            String(format: "%02x", $0)
        }.joined()
    }

    func isValidPoW() -> Bool {
        hash.hasPrefix(String(repeating: "0", count: difficulty))
    }

    static func genesis(difficulty: Int) -> Block {
        Block(index: 0,
              prevHash: String(repeating: "0", count: 64),
              timestamp: Date().timeIntervalSince1970,
              data: "genesis",
              difficulty: difficulty,
              nonce: 0
        )
    }
}
