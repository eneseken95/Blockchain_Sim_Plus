//
//  ConsensusEngine.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 27.10.2025.
//

import Foundation

public protocol ConsensusEngine {
    var name: String { get }
    func reset()
    func run(parameters: [String: Any]) -> ConsensusResult
}

public struct ConsensusResult {
    public let logs: [String]
    public let metrics: [String: String]
    public let samples: [MetricSample]
}

public struct MetricSample: Identifiable {
    public let id = UUID()
    public let series: String
    public let x: Double
    public let y: Double
}
