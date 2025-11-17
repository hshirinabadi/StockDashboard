//
//  StockSearchBarController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import UIKit

final class StockSearchBarController: NSObject, UISearchResultsUpdating {
    
    let searchController: UISearchController
    var onSearchTextChanged: ((String) -> Void)?
    
    override init() {
        self.searchController = UISearchController(searchResultsController: nil)
        super.init()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search companies or tickers"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        onSearchTextChanged?(text)
    }
}


