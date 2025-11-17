//
//  StockDetailAIRecommendationSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import UIKit

struct StockDetailAIRecommendationSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .aiRecommendation
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(
            StockDetailAIRecommendationCell.self,
            forCellWithReuseIdentifier: StockDetailAIRecommendationCell.reuseIdentifier
        )
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(120)
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
            withReuseIdentifier: StockDetailAIRecommendationCell.reuseIdentifier,
            for: indexPath
        ) as! StockDetailAIRecommendationCell
        
        cell.configure(state: state.recommendationState)
        
        return cell
    }
}


