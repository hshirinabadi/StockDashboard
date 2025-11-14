//
//  StockDetailKeyStatsSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

struct StockDetailKeyStatsSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .keyStats
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(StockDetailKeyStatsCell.self, forCellWithReuseIdentifier: StockDetailKeyStatsCell.reuseIdentifier)
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(160)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: StockDetailItem,
        state: StockDetailViewState
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StockDetailKeyStatsCell.reuseIdentifier,
            for: indexPath
        ) as! StockDetailKeyStatsCell
        
        if let quote = state.quote {
            let stats = [
                (label: "Open", value: StockDashboardUtils.formatPrice(quote.open)),
                (label: "High", value: StockDashboardUtils.formatPrice(quote.high)),
                (label: "Low", value: StockDashboardUtils.formatPrice(quote.low)),
                (label: "Prev Close", value: StockDashboardUtils.formatPrice(quote.previousClose))
            ]
            
            cell.configure(title: "Key Stats", stats: stats)
        }
        
        return cell
    }
}


