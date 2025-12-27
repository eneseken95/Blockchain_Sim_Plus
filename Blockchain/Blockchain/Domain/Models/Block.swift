//
//  Block.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

import CryptoKit
import Foundation

public struct Block: Identifiable, Codable {
    /// Unique identifier for the block (calculated from its hash)
    public var id: String { hash }
    
    /// The position of the block in the chain (0 = Genesis)
    let index: Int
    
    /// The cryptographic hash of the previous block, linking them together
    let prevHash: String
    
    /// When the block was created
    let timestamp: TimeInterval
    
    /// The actual information stored in the block (e.g., transactions)
    var data: String
    
    /// The mining difficulty target for this block
    var difficulty: Int
    
    /// 'Number used once' - the variable miners change to solve the puzzle
    var nonce: UInt64
    
    /// Digital signature for authenticity (optional)
    var signature: Data? = nil
    
    /// Public key of the signer (optional)
    var publicKey: Data? = nil

    /// Combines all critical fields into a single string for hashing
    var header: String {
        "\(index)|\(prevHash)|\(String(format: "%.3f", timestamp))|\(data)|\(nonce)|\(difficulty)"
    }

    /// Converts the header string to raw data bytes
    var headerData: Data {
        Data(header.utf8)
    }

    /// Calculates the SHA-256 hash of the block header
    /// This is the "fingerprint" of the block. Changing ANY field changes this hash completely.
    var hash: String {
        let digest = SHA256.hash(data: headerData)
        return digest.map {
            String(format: "%02x", $0)
        }.joined()
    }

    /// Checks if the block's hash meets the Proof of Work difficulty requirement.
    /// Example: If difficulty is 3, the hash must start with "000".
    func isValidPoW() -> Bool {
        hash.hasPrefix(String(repeating: "0", count: difficulty))
    }

    /// Creates the very first block in the chain (Genesis Block)
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
