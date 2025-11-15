//
//  StockDetailViewController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    private lazy var stockDetailView = StockDetailView()
    private let viewModel: StockDetailViewModel
    
    init(symbol: String) {
        self.viewModel = StockDetailViewModel(symbol: symbol)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startPricePolling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopPricePolling()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        stockDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stockDetailView)
        NSLayoutConstraint.activate([
            stockDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stockDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stockDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stockDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        stockDetailView.bind(to: viewModel.viewStatePublisher)
        stockDetailView.bindQuote(to: viewModel.quotePublisher)
    }
}
