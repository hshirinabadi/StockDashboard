//
//  StockDetailCompanyInfoSectionController.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

struct StockDetailCompanyInfoSectionController: StockDetailSectionController {
    let sectionType: StockDetailSectionType = .companyInfo
    
    func registerCells(on collectionView: UICollectionView) {
        collectionView.register(StockDetailInfoCell.self, forCellWithReuseIdentifier: StockDetailInfoCell.reuseIdentifier)
    }
    
    func layoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
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
            withReuseIdentifier: StockDetailInfoCell.reuseIdentifier,
            for: indexPath
        ) as! StockDetailInfoCell
        
        if let profile = state.companyProfile {
            var infoItems: [(title: String, value: String)] = []
            
            if let industry = profile.finnhubIndustry {
                infoItems.append((title: "Industry", value: industry))
            }
            
            if let exchange = profile.exchange {
                infoItems.append((title: "Exchange", value: exchange))
            }
            
            if let marketCap = profile.marketCapitalization {
                infoItems.append((title: "Market Cap", value: StockDashboardUtils.formatMarketCap(marketCap)))
            }
            
            infoItems.append((title: "P/E Ratio", value: "—"))
            
            cell.configure(title: "Company Info", infoItems: infoItems)
        }
        
        return cell
    }
}


