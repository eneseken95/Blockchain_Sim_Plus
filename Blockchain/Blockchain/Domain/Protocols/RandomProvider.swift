//
//  RandomProvider.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

public protocol RandomProvider {
    func int(in: ClosedRange<Int>) -> Int
    func double() -> Double
    func weightedIndex(weights: [Int]) -> Int?
}
