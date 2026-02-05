//
//  StockDetailNewsRowView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct StockDetailNewsRowView: View {
    let article: NewsArticle

    var body: some View {
        // In UIKit, tapping used UITapGestureRecognizer + @objc handler + tapHandler closure.
        // In SwiftUI, Link opens a URL directly — no gesture recognizer needed.
        
        Link(destination: URL(string: article.url)!) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.headline)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Text("\(article.source) · \(StockDashboardUtils.relativeTimeString(for: article.date))")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                // In UIKit, image loading was 30 lines of manual URLSession code
                // with Task, cancellation checks, prepareForReuse cleanup.
                // AsyncImage handles all of that in one call.
                AsyncImage(url: URL(string: article.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.tertiarySystemFill)
                }
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
    
}
