//
//  ChatCompletion.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

struct ChatMessage: Encodable {
    let role: String
    let content: String
}

struct ChatRequestBody: Encodable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
}

struct ChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
