//
//  TransactionTests.swift
//  BlockchainTests
//
//  Created by Enes Eken on 27.10.2025.
//

import XCTest
import CryptoKit
@testable import BlockchainLogic

final class TransactionTests: XCTestCase {

    func testTransactionSigningAndVerification() {
        // 1. Create two wallets (Alice and Bob)
        let alice = Wallet()
        let bob = Wallet()
        
        // 2. Alice sends 10 coins to Bob
        var tx = alice.send(amount: 10.0, to: bob.address)
        
        // 3. Verify the transaction details
        XCTAssertEqual(tx.sender, alice.address)
        XCTAssertEqual(tx.receiver, bob.address)
        XCTAssertEqual(tx.amount, 10.0)
        XCTAssertNotNil(tx.signature, "Transaction must differ a signature")
        
        // 4. Manual Verification Logic (mimicking what a Node does)
        // We need Alice's Public Key to verify her signature
        let isValid = verifySignature(tx: tx, publicKey: alice.publicKey)
        XCTAssertTrue(isValid, "Signature verification should pass for valid transaction")
    }
    
    func testTemperedTransactionFailsVerification() {
        let alice = Wallet()
        let bob = Wallet()
        
        // Alice validly signs a transaction
        var tx = alice.send(amount: 10.0, to: bob.address)
        
        // ATTACK: Man-in-the-middle changes the amount from 10 to 100!
        // But they cannot regenerate the signature because they don't have Alice's Private Key.
        let originalSignature = tx.signature
        
        // We simulate a new transaction object with tempered data but old signature
        var temperedTx = Transaction(
            id: tx.id,
            sender: tx.sender,
            receiver: tx.receiver,
            amount: 100.0, // Changed!
            timestamp: tx.timestamp
        )
        temperedTx.signature = originalSignature
        
        let isValid = verifySignature(tx: temperedTx, publicKey: alice.publicKey)
        XCTAssertFalse(isValid, "Signature verification MUST fail if data is changed")
    }
    
    // Helper to verify signature using CryptoKit
    private func verifySignature(tx: Transaction, publicKey: P256.Signing.PublicKey) -> Bool {
        guard let signatureData = tx.signature else { return false }
        
        do {
            let signature = try P256.Signing.ECDSASignature(derRepresentation: signatureData)
            return publicKey.isValidSignature(signature, for: tx.dataToSign)
        } catch {
            return false
        }
    }
}
