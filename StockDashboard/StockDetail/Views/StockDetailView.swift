//
//  StockDetailView.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit
import Combine

class StockDetailView: UIView {
    
    private typealias Section = StockDetailSectionType
    private typealias Item = StockDetailItem
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self, sectionIndex < self.currentSections.count else {
                return nil
            }
            let controller = self.currentSections[sectionIndex].controller
            return controller.layoutSection(environment: environment)
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    // MARK: - Properties
    private lazy var loadingStateView = LoadingStateView()
    private lazy var errorStateView = ErrorStateView()
    
    private var dataSource: DataSource!
    private var currentSections: [Section] = []
    private weak var quoteCell: StockDetailQuoteCell?
    
    private var viewState: StockDetailViewState = .initial(symbol: "") {
        didSet {
            updateUI()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func bind(to publisher: AnyPublisher<StockDetailViewState, Never>) {
        publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.viewState = state
            }
            .store(in: &cancellables)
    }
    
    func bindQuote(to publisher: AnyPublisher<Quote?, Never>) {
        publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] quote in
                guard let self, let quote = quote else { return }
                self.updateQuote(quote)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        
        loadingStateView.translatesAutoresizingMaskIntoConstraints = false
        errorStateView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loadingStateView)
        addSubview(errorStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingStateView.topAnchor.constraint(equalTo: topAnchor),
            loadingStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingStateView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            errorStateView.topAnchor.constraint(equalTo: topAnchor),
            errorStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorStateView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        resetToInitialState()
    }
    
    private func configureDataSource() {
        // Register cells for every possible section type once
        StockDetailSectionType.allCases
            .map { $0.controller }
            .forEach { controller in
                controller.registerCells(on: collectionView)
            }
        
        dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else {
                return UICollectionViewCell()
            }
            
            let sectionType = itemIdentifier.section
            
            let cell = sectionType.controller.configureCell(
                collectionView: collectionView,
                indexPath: indexPath,
                item: itemIdentifier,
                state: self.viewState
            )
            
            if sectionType == .quote, let quoteCell = cell as? StockDetailQuoteCell {
                self.quoteCell = quoteCell
            }
            
            return cell
        }
    }
    
    private func updateUI() {
        resetToInitialState()
        
        switch viewState.state {
        case .loading:
            loadingStateView.isHidden = false
            loadingStateView.startAnimating()
            
        case .loaded:
            collectionView.isHidden = false
            applySnapshot(for: viewState)
            
        case .error(let message):
            errorStateView.isHidden = false
            errorStateView.configure(message: message)
        }
    }
    
    private func resetToInitialState() {
        collectionView.isHidden = true
        loadingStateView.isHidden = true
        errorStateView.isHidden = true
        loadingStateView.stopAnimating()
    }
    
    private func applySnapshot(for state: StockDetailViewState) {
        guard state.state == .loaded else { return }
        
        currentSections = state.sections.map { $0.type }
        
        var snapshot = Snapshot()
        
        for section in state.sections {
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.items, toSection: section.type)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateQuote(_ quote: Quote) {
        guard let quoteCell else { return }
        let exchange = viewState.companyProfile?.exchange
        let currency = viewState.companyProfile?.currency
        quoteCell.configure(quote: quote, exchange: exchange, currency: currency)
    }
}


