//
//  StockDetailSectionType.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//


enum StockDetailSectionType: Int, CaseIterable {
    case header
    case quote
    case aiRecommendation
    case companyInfo
    case keyStats
    case news
    
    var title: String? {
        switch self {
        case .header: return nil
        case .quote: return nil
        case .aiRecommendation: return "AI Insight"
        case .companyInfo: return "Company Info"
        case .keyStats: return "Key Stats"
        case .news: return "Latest News"
        }
    }
    
    var controller: StockDetailSectionController {
        switch self {
        case .header:
            return StockDetailHeaderSectionController()
        case .quote:
            return StockDetailQuoteSectionController()
        case .aiRecommendation:
            return StockDetailAIRecommendationSectionController()
        case .companyInfo:
            return StockDetailCompanyInfoSectionController()
        case .keyStats:
            return StockDetailKeyStatsSectionController()
        case .news:
            return StockDetailNewsSectionController()
        }
    }
}
