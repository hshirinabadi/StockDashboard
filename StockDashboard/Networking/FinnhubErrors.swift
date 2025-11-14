//
//  FinnhubErrors.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

enum FinnhubError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL requested"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server returned error code: \(code)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
