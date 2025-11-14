//
//  StockDetailHeaderSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

struct StockDetailHeaderSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .header
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(StockDetailHeaderCell.self, forCellWithReuseIdentifier: StockDetailHeaderCell.reuseIdentifier)
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
            withReuseIdentifier: StockDetailHeaderCell.reuseIdentifier,
            for: indexPath
        ) as! StockDetailHeaderCell
        cell.configure(symbol: state.symbol, companyName: state.companyProfile?.name)
        return cell
    }
}


