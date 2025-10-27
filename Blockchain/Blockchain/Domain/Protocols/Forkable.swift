//
//  Forkable.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

import Foundation

public protocol Forkable {
    func simulateForks(miners: Int, rounds: Int, forkProb: Double) -> (logs: [String], metrics: [String: String], samples: [MetricSample])
}
