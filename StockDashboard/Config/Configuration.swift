//
//  Configuration.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey(String)
        case invalidValue(String)
    }
    
    enum ConfigKey: String {
        case finnhubApiKey = "FINNHUB_API_KEY"
        case openAIAPIKey = "OPENAI_API_KEY"
    }
    
    static func value<T>(for key: ConfigKey) throws -> T where T: LosslessStringConvertible {
        guard let value = ProcessInfo.processInfo.environment[key.rawValue] else {
            throw Error.missingKey(key.rawValue)
        }
        
        guard let typedValue = T(value) else {
            throw Error.invalidValue(value)
        }
        
        return typedValue
    }
    
    static var finnhubApiKey: String {
        do {
            return try value(for: .finnhubApiKey)
        } catch {
            return "MISSING_API_KEY"
        }
    }
    
    static var openAIAPIKey: String? {
        // OpenAI integration is optional
        return ProcessInfo.processInfo.environment[ConfigKey.openAIAPIKey.rawValue]
    }
}
