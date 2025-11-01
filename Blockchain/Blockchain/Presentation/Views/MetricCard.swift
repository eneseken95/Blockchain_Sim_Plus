//
//  MetricCard.swift
//  Blockchain
//
//  Created by Enes Eken 2 on 1.11.2025.
//

import SwiftUI

struct MetricCard: View {
    let title: String; let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
