//
//  StockDetailHeaderCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailHeaderCell"
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(symbolLabel)
        contentView.addSubview(companyNameLabel)
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            companyNameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            companyNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            companyNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            companyNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(symbol: String, companyName: String?) {
        symbolLabel.text = symbol
        companyNameLabel.text = companyName ?? "Loading..."
    }
}
