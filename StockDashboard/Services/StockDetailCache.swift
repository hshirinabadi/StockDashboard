//
//  StockDetailCache.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import Foundation

struct CachedStockDetail {
    let symbol: String
    let quote: Quote
    let profile: CompanyProfile
    let news: [NewsArticle]
    let timestamp: Date
}

protocol StockDetailCacheProtocol {
    func cachedDetail(forKey symbol: String) -> CachedStockDetail?
    func setCachedDetail(_ detail: CachedStockDetail, forKey symbol: String)
}

final class InMemoryStockDetailCache: StockDetailCacheProtocol {
    
    static let shared = InMemoryStockDetailCache()
    
    private final class CacheEntry: NSObject {
        let detail: CachedStockDetail
        
        init(detail: CachedStockDetail) {
            self.detail = detail
        }
    }
    
    private let ttl: TimeInterval
    private let cache = NSCache<NSString, CacheEntry>()
    
    private init(ttl: TimeInterval = 5 * 60, maxEntries: Int = 10) {
        self.ttl = ttl
        cache.countLimit = maxEntries
    }
    
    func cachedDetail(forKey symbol: String) -> CachedStockDetail? {
        guard let entry = cache.object(forKey: symbol as NSString) else { return nil }
        let cached = entry.detail
        
        let age = Date().timeIntervalSince(cached.timestamp)
        if age > ttl {
            cache.removeObject(forKey: symbol as NSString)
            return nil
        }
        
        return cached
    }
    
    func setCachedDetail(_ detail: CachedStockDetail, forKey symbol: String) {
        let entry = CacheEntry(detail: detail)
        cache.setObject(entry, forKey: symbol as NSString)
    }
}



