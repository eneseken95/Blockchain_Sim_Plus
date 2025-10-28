//
//  CryptoKitSigner.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

import CryptoKit
import Foundation

final class CryptoKitSigner: Signer {
    private let privateKey = P256.Signing.PrivateKey()

    func publicKeyBytes() -> Data {
        privateKey.publicKey.rawRepresentation
    }

    func sign(_ data: Data) throws -> Data {
        try privateKey.signature(for: data).derRepresentation
    }

    func verify(_ data: Data, signature: Data, publicKey: Data) -> Bool {
        guard let pub = try? P256.Signing.PublicKey(rawRepresentation: publicKey) else {
            return false
        }

        guard let sig = try? P256.Signing.ECDSASignature(derRepresentation: signature) else {
            return false
        }
        return pub.isValidSignature(sig, for: data)
    }
}
