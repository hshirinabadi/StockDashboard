//
//  StockDetailAIRecommendationView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import SwiftUI

struct StockDetailAIRecommendationView: View {
    let state: StockDetailViewState.RecommendationState

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row: title + badge
            // In UIKit this was a UIStackView with a UIView() spacer between title and badge.
            // In SwiftUI, Spacer() pushes the badge to the trailing edge.
            HStack {
                Text("AI Insight")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                if case .loaded(let rec) = state {
                    badgeView(for: rec.action)
                }
            }

            // In UIKit, we toggled isHidden on multiple labels.
            // In SwiftUI, we use switch — only the matching case renders.
            switch state {
            case .loading:
                Text("Fetching AI-powered recommendation…")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)

            case .failed(let message):
                Text("AI recommendation unavailable: \(message)")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)

            case .loaded(let recommendation):
                Text("Confidence: \(Int(recommendation.confidence * 100))%")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Text(recommendation.rationale)
                    .font(.system(size: 14))
            }

            Text("This AI-generated view is for informational purposes only and is not financial advice.")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func badgeView(for action: StockRecommendationAction) -> some View {
        let (bgColor, fgColor): (Color, Color) = {
            switch action {
            case .buy: return (Color.green.opacity(0.15), .green)
            case .hold: return (Color(.systemGray5), Color.primary)
            case .sell: return (Color.red.opacity(0.15), .red)
            }
        }()

        Text(action.rawValue)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 10)
            .frame(minWidth: 60, minHeight: 24)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(bgColor)
            )
            .foregroundStyle(fgColor)
    }
}
