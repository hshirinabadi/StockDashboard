//
//  StockSearchView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit
import Combine

typealias SearchViewDidSelectSymbolBlock = ((Int) -> Void)

class StockSearchView: UIView {
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchSymbolCollectionViewCell.self, forCellWithReuseIdentifier: SearchSymbolCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var errorStateView: ErrorStateView = {
        let view = ErrorStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingStateView: LoadingStateView = {
        let view = LoadingStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Properties
    var selectSymbolBlock: SearchViewDidSelectSymbolBlock?
    
    private var viewState: StockSearchViewState = .initial {
        didSet {
            updateUI()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func bind(to viewStatePublisher: AnyPublisher<StockSearchViewState, Never>) {
        cancellables.removeAll()
        viewStatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newState in
                self?.viewState = newState
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        addSubview(emptyStateView)
        addSubview(errorStateView)
        addSubview(loadingStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            errorStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorStateView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadingStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingStateView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingStateView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateUI() {
        
        switch viewState.state {
        case .initial:
            resetToInitialState()
            emptyStateView.isHidden = false
            emptyStateView.configure(message: "Search for a company or ticker symbol")
            
        case .loading:
            loadingStateView.isHidden = false
            loadingStateView.startAnimating()
            
        case .results:
            resetToInitialState()
            collectionView.isHidden = false
            collectionView.reloadData()
            
        case .empty(let message):
            resetToInitialState()
            emptyStateView.isHidden = false
            let formattedMessage = "No results found for \"\(message)\""
            emptyStateView.configure(message: formattedMessage)
            
        case .error(let message):
            resetToInitialState()
            errorStateView.isHidden = false
            errorStateView.configure(message: message)
        }
    }
    
    private func resetToInitialState() {
        emptyStateView.isHidden = true
        errorStateView.isHidden = true
        collectionView.isHidden = true
        loadingStateView.isHidden = true
        loadingStateView.stopAnimating()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension StockSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState.symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchSymbolCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchSymbolCollectionViewCell, indexPath.row < viewState.symbols.count else {
            return UICollectionViewCell()
        }
        
        let symbolResult = viewState.symbols[indexPath.row]
        cell.configure(with: symbolResult)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectSymbolBlock?(indexPath.row)
    }
}
