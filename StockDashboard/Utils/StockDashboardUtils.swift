//
//  StockDashboardUtils.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

enum StockDashboardUtils {
    
    static func formatPrice(_ price: Double) -> String {
        return "$\(String(format: "%.2f", price))"
    }
    
    static func formatChange(_ change: Double, percentChange: Double) -> String {
        let changeFormatted = String(format: "%.2f", abs(change))
        let percentFormatted = String(format: "%.2f", abs(percentChange))
        let prefix = change >= 0 ? "+" : "-"
        return "\(prefix)$\(changeFormatted) (\(prefix)\(percentFormatted)%)"
    }
    
    static func formatMarketCap(_ marketCap: Double) -> String {
        if marketCap >= 1_000_000 {
            return "$\(String(format: "%.2f", marketCap / 1_000_000))T"
        } else if marketCap >= 1_000 {
            return "$\(String(format: "%.2f", marketCap / 1_000))B"
        } else {
            return "$\(String(format: "%.2f", marketCap))M"
        }
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    static func relativeTimeString(for date: Date) -> String {
        let now = Date()
        let seconds = Int(now.timeIntervalSince(date))
        
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86_400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}
