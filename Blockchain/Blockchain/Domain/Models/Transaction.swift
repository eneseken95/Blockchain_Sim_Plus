//
//  Transaction.swift
//  Blockchain
//
//  Created by Enes Eken on 27.10.2025.
//

import Foundation

/// Represents a value transfer between two parties.
/// In a real blockchain, transactions are grouped into Blocks.
public struct Transaction: Codable, Identifiable {
    public var id: UUID = UUID()
    
    /// The public address of the sender (derived from Public Key)
    public let sender: String
    
    /// The public address of the receiver
    public let receiver: String
    
    /// The amount of coins to transfer
    public let amount: Double
    
    /// When this transaction was created
    public let timestamp: TimeInterval
    
    /// The digital signature proving the sender authorized this.
    /// This is crucial! Without this, anyone could spend anyone else's money.
    public var signature: Data? = nil
    
    /// Combines critical fields to be signed/hashed.
    /// Note: We do NOT include the signature itself in the signed data (that would be recursive).
    public var dataToSign: Data {
        let str = "\(sender)|\(receiver)|\(amount)|\(timestamp)"
        return Data(str.utf8)
    }
}
