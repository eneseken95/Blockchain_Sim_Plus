//
//  AppContainer.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 30.10.2025.
//

final class AppContainer {
    static let shared = AppContainer()
    let rng: RandomProvider = SystemRandomProvider()
    let logger: Logger = ConsoleLogger()
    let signer: Signer = CryptoKitSigner()

    func makePoW() -> ConsensusEngine {
        PoWEngine(store: InMemoryChainStore(), logger: logger, signer: signer)
    }

    func makePoS() -> ConsensusEngine {
        PoSEngine(store: InMemoryChainStore(), logger: logger, rng: rng)
    }

    func makePoWFork(difficulty: Int) -> Forkable {
        PoWForkEngine(difficulty: difficulty)
    }
}
