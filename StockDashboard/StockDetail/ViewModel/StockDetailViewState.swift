//
//  StockDetailViewState.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

struct StockDetailViewState {
    enum State: Equatable {
        case loading
        case loaded
        case error(message: String)
    }
    
    enum RecommendationState: Equatable {
        case loading
        case loaded(StockRecommendation)
        case failed(String)
    }
    
    var state: State
    var symbol: String
    var quote: Quote?
    var companyProfile: CompanyProfile?
    var sections: [StockDetailSection]
    var news: [NewsArticle]
    var recommendationState: RecommendationState
    
    static func initial(symbol: String) -> StockDetailViewState {
        return StockDetailViewState(
            state: .loading,
            symbol: symbol,
            quote: nil,
            companyProfile: nil,
            sections: [],
            news: [],
            recommendationState: .loading
        )
    }
    
    mutating func updateWithResults(_ quote: Quote, _ profile: CompanyProfile, news: [NewsArticle]) {
        self.quote = quote
        self.companyProfile = profile
        self.news = news
        self.state = .loaded
    }
    
    mutating func updateWithError(_ message: String) {
        self.state = .error(message: message)
    }
}
