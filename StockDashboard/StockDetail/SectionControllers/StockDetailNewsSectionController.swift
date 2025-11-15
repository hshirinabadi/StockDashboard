//
//  StockDetailNewsSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

struct StockDetailNewsSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .news
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(StockDetailNewsHeaderCell.self, forCellWithReuseIdentifier: StockDetailNewsHeaderCell.reuseIdentifier)
        collectionView.register(StockDetailNewsListCell.self, forCellWithReuseIdentifier: StockDetailNewsListCell.reuseIdentifier)
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(180)
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
        if let headerId = item.id as? String, headerId == "newsHeader" {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StockDetailNewsHeaderCell.reuseIdentifier,
                for: indexPath
            ) as! StockDetailNewsHeaderCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StockDetailNewsListCell.reuseIdentifier,
                for: indexPath
            ) as! StockDetailNewsListCell
            
            if let id = item.id as? Int,
               let article = state.news.first(where: { $0.id == id }) {
                cell.configure(with: article)
            }
            return cell
        }
    }
}



