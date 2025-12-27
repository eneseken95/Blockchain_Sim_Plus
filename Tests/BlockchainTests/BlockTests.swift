import XCTest
@testable import BlockchainLogic

final class BlockTests: XCTestCase {
    
    func testGenesisBlock() {
        let difficulty = 4
        let genesis = Block.genesis(difficulty: difficulty)
        
        XCTAssertEqual(genesis.index, 0)
        XCTAssertEqual(genesis.data, "genesis")
        XCTAssertEqual(genesis.difficulty, difficulty)
        XCTAssertEqual(genesis.prevHash, String(repeating: "0", count: 64))
    }
    
    func testBlockHashConsistency() {
        let block = Block(
            index: 1,
            prevHash: "abc",
            timestamp: 1234567890,
            data: "Test Data",
            difficulty: 2,
            nonce: 0
        )
        
        let hash1 = block.hash
        let hash2 = block.hash
        
        XCTAssertEqual(hash1, hash2, "Hash should be deterministic")
        XCTAssertFalse(hash1.isEmpty)
    }
    
    func testValidPoW() {
        // Create a block with a nonce that satisfies difficulty 1 (prefix "0")
        // We might need to mine it manually or mock it.
        // For unit test simplicity, let's just check the validation logic itself.
        
        // Case 1: Hash allows validation
        // We can't easily force a hash without finding a nonce, 
        // but we can check if the function checks the hash property.
        
        var block = Block.genesis(difficulty: 1)
        // Find a nonce that works
        var found = false
        for i in 0...100000 {
            block.nonce = UInt64(i)
            if block.isValidPoW() {
                found = true
                break
            }
        }
        
        XCTAssertTrue(found, "Should find a valid nonce for low difficulty")
        XCTAssertTrue(block.hash.hasPrefix("0"))
    }
}
