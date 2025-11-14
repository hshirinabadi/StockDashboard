//
//  StockSearchViewController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit
import Combine

class StockSearchViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchView = StockSearchView()

    private let viewModel = StockSearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController = searchController
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Stock Search"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search companies or tickers"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSearchView() {
        // Bind view to state
        searchView.bind(to: viewModel.viewStatePublisher)
        
        searchView.selectSymbolBlock = { [weak self] index in
            guard let self = self, index < self.viewModel.viewState.symbols.count else { return }
            let selectedSymbol = self.viewModel.viewState.symbols[index]
            let detailVC = StockDetailViewController(symbol: selectedSymbol.symbol)
            detailVC.title = selectedSymbol.description
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension StockSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.setSearchQuery(searchText)
    }
}



