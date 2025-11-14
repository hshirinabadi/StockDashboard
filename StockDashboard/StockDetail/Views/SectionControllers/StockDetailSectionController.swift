//
//  StockDetailSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

protocol StockDetailSectionController {
    var sectionType: StockDetailSectionType { get }
    func registerCells(on collectionView: UICollectionView)
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: StockDetailItem,
        state: StockDetailViewState
    ) -> UICollectionViewCell
}


