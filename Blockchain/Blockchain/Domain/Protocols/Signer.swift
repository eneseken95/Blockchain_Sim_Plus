//
//  Signer.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

import Foundation

public protocol Signer {
    func publicKeyBytes() -> Data
    func sign(_ data: Data) throws -> Data
    func verify(_ data: Data, signature: Data, publicKey: Data) -> Bool
}
