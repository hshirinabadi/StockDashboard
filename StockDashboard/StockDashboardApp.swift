//
//  StockDashboardApp.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import SwiftUI

@main
struct StockDashboardApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StockSearchView()
            }
        }
    }
}
