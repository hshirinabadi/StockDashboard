//
//  StockDetailKeyStatsView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailKeyStatsView: View {
    let title: String
    let stats: [(label: String, value: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))

            // In UIKit, the grid was built manually by creating UIStackView rows
            // with pairs of stat views. In SwiftUI, LazyVGrid does this declaratively.
            // Grid with 2 columns, same as the UIKit version's index % 2 logic.
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(stats.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(stats[index].label)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        Text(stats[index].value)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
    }
}
