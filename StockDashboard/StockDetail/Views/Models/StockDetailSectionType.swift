//
//  StockDetailSectionType.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//


enum StockDetailSectionType: Int, CaseIterable {
    case header
    case quote
    case companyInfo
    case keyStats
    case news
    
    var title: String? {
        switch self {
        case .header: return nil
        case .quote: return nil
        case .companyInfo: return "Company Info"
        case .keyStats: return "Key Stats"
        case .news: return "Latest News"
        }
    }
}
