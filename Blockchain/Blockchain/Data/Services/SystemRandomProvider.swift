//
//  SystemRandomProvider.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 28.10.2025.
//

final class SystemRandomProvider: RandomProvider {
    func int(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range)
    }

    func double() -> Double {
        Double.random(in: 0 ... 1)
    }

    func weightedIndex(weights: [Int]) -> Int? {
        let total = weights.reduce(0,+); guard total > 0 else {
            return nil
        }

        let r = int(in: 1 ... total); var acc = 0

        for (i, w) in weights.enumerated() {
            acc += max(0, w); if r <= acc { return i }
        }
        return nil
    }
}
