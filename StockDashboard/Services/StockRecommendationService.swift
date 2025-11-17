//
//  StockRecommendationService.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import Foundation

final class OpenAIStockRecommendationService: StockRecommendationServiceProtocol {
    
    private let apiKey: String
    private let session: URLSession
    private let model: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init?(session: URLSession = .shared, model: String = "gpt-4.1-mini") {
        guard let key = Configuration.openAIAPIKey else {
            return nil
        }
        self.apiKey = key
        self.session = session
        self.model = model
    }
    
    func recommendation(
        for symbol: String,
        quote: Quote,
        profile: CompanyProfile?,
        news: [NewsArticle]
    ) async throws -> StockRecommendation {
        
        let systemPrompt = """
        You are an investment assistant. Given a stock's basic fundamentals and a few recent headlines,
        you must return a BUY, HOLD, or SELL recommendation along with a short rationale and a confidence
        score between 0 and 1. This is strictly informational and not financial advice.
        Output JSON only in the following format:
        {
          "action": "BUY" | "HOLD" | "SELL",
          "confidence": 0.0-1.0,
          "rationale": "short explanation"
        }
        """
        
        let profileSummary = [
            profile?.name,
            profile?.finnhubIndustry,
            profile?.exchange
        ]
        .compactMap { $0 }
        .joined(separator: " · ")
        
        let newsSnippets = news
            .prefix(10)
            .map { "- \($0.source): \($0.headline)" }
            .joined(separator: "\n")
        
        let userPrompt = """
        Symbol: \(symbol)
        Current price: \(quote.currentPrice)
        Daily change: \(quote.change) (\(quote.percentChange)%)
        Today's range: \(quote.low) - \(quote.high)
        Company: \(profileSummary)
        
        Recent news:
        \(newsSnippets.isEmpty ? "None" : newsSnippets)
        """
        
        let body = ChatRequestBody(
            model: model,
            messages: [
                ChatMessage(role: "system", content: systemPrompt),
                ChatMessage(role: "user", content: userPrompt)
            ],
            temperature: 0.2
        )
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let content = response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines),
              let jsonStart = content.firstIndex(of: "{"),
              let jsonEnd = content.lastIndex(of: "}") else {
            throw NSError(domain: "OpenAIStockRecommendationService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid model output"])
        }
        
        let jsonSubstring = content[jsonStart...jsonEnd]
        let jsonData = Data(jsonSubstring.utf8)
        let payload = try JSONDecoder().decode(RecommendationPayload.self, from: jsonData)
        
        return StockRecommendation(
            action: payload.action,
            confidence: payload.confidence,
            rationale: payload.rationale
        )
    }
}


