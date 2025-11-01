//
//  ChartsView.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 1.11.2025.
//

import Charts
import SwiftUI

struct ChartsView: View {
    let samples: [MetricSample]

    var body: some View {
        Chart(samples) { s in
            LineMark(
                x: .value("x", s.x),
                y: .value("y", s.y)
            )
            .foregroundStyle(by: .value("series", s.series))
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("x", s.x),
                y: .value("y", s.y)
            )
            .foregroundStyle(by: .value("series", s.series))
            .symbolSize(20)
            .opacity(0.9)
        }
        .frame(height: 220)
    }
}
