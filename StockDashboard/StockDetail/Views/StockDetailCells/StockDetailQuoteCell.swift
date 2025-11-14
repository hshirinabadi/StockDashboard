//
//  StockDetailQuoteCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailQuoteCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailQuoteCell"
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exchangeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeLabel)
        contentView.addSubview(exchangeInfoLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            changeLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            changeLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),
            changeLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            exchangeInfoLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            exchangeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            exchangeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            exchangeInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(quote: Quote, exchange: String?, currency: String?) {
        priceLabel.text = StockDashboardUtils.formatPrice(quote.currentPrice)
        
        let changeText = StockDashboardUtils.formatChange(quote.change, percentChange: quote.percentChange)
        changeLabel.text = changeText
        changeLabel.textColor = quote.percentChange >= 0 ? .systemGreen : .systemRed
        
        let exchangeText = exchange ?? ""
        let currencyText = currency ?? "USD"
        exchangeInfoLabel.text = "\(exchangeText) · \(currencyText)"
    }
}
