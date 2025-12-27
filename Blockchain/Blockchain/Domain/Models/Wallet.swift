//
//  Wallet.swift
//  Blockchain
//
//  Created by Enes Eken on 27.10.2025.
//

import Foundation
import CryptoKit

/// Represents a user's wallet in the blockchain.
/// A wallet is essentially a Private Key + Public Key pair.
public class Wallet {
    /// The secret key used to sign transactions. NEVER share this!
    private let privateKey: P256.Signing.PrivateKey
    
    /// The public key, which effectively acts as the user's address.
    /// Others verify signatures using this key.
    public let publicKey: P256.Signing.PublicKey
    
    /// User's unique ID derived from the public key (simplified address)
    public var address: String {
        publicKey.rawRepresentation.map { String(format: "%02x", $0) }.joined()
    }
    
    public init() {
        // Generate a new random key pair
        self.privateKey = P256.Signing.PrivateKey()
        self.publicKey = privateKey.publicKey
    }
    
    /// Creates and signs a transaction.
    /// - Parameters:
    ///   - receiverAddress: The public address of the recipient
    ///   - amount: Amount to send
    /// - Returns: A complete, signed Transaction object
    public func send(amount: Double, to receiverAddress: String) -> Transaction {
        var tx = Transaction(
            sender: self.address,
            receiver: receiverAddress,
            amount: amount,
            timestamp: Date().timeIntervalSince1970
        )
        
        // Sign the transaction data with our Private Key
        // This produces a digital signature
        do {
            let signature = try privateKey.signature(for: tx.dataToSign)
            tx.signature = signature.derRepresentation
        } catch {
            print("Error signing transaction: \(error)")
        }
        
        return tx
    }
}
