//
//  StockSearchViewController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit
import Combine

class StockSearchViewController: UIViewController {
    
    private let searchBarController = StockSearchBarController()
    private let searchView = StockSearchView()

    private let viewModel = StockSearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Stock Search"
        
        navigationItem.searchController = searchBarController.searchController
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
    
    private func setupBindings() {
        // Bind view to state
        searchView.bind(to: viewModel.viewStatePublisher)
        
        searchView.selectSymbolBlock = { [weak self] index in
            guard let self = self, index < self.viewModel.viewState.symbols.count else { return }
            let selectedSymbol = self.viewModel.viewState.symbols[index]
            let detailVC = StockDetailViewController(symbol: selectedSymbol.symbol)
            detailVC.title = selectedSymbol.description
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        searchBarController.onSearchTextChanged = { [weak self] query in
            self?.viewModel.setSearchQuery(query)
        }
    }
}

