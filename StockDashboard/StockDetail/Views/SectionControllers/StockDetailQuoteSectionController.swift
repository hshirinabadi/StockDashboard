//
//  StockDetailQuoteSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

struct StockDetailQuoteSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .quote
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(StockDetailQuoteCell.self, forCellWithReuseIdentifier: StockDetailQuoteCell.reuseIdentifier)
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
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
            withReuseIdentifier: StockDetailQuoteCell.reuseIdentifier,
            for: indexPath
        ) as! StockDetailQuoteCell
        
        if let quote = state.quote {
            cell.configure(
                quote: quote,
                exchange: state.companyProfile?.exchange,
                currency: state.companyProfile?.currency
            )
        }
        
        return cell
    }
}


