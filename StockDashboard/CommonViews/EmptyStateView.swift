//
//  EmptyStateView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.system(size: 16))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
