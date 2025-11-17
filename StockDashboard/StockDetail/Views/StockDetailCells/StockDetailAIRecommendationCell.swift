//
//  StockDetailAIRecommendationCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/16/25.
//

import UIKit

class StockDetailAIRecommendationCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailAIRecommendationCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "AI Insight"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confidenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rationaleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = "Fetching AI-powered recommendation…"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 0
        label.text = "This AI-generated view is for informational purposes only and is not financial advice."
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
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(badgeLabel)
        contentView.addSubview(confidenceLabel)
        contentView.addSubview(rationaleLabel)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            badgeLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),
            
            confidenceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            confidenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            confidenceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            
            rationaleLabel.topAnchor.constraint(equalTo: confidenceLabel.bottomAnchor, constant: 8),
            rationaleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rationaleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            disclaimerLabel.topAnchor.constraint(equalTo: rationaleLabel.bottomAnchor, constant: 8),
            disclaimerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            disclaimerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(state: StockDetailViewState.RecommendationState) {
        switch state {
        case .loading:
            placeholderLabel.isHidden = false
            placeholderLabel.text = "Fetching AI-powered recommendation…"
            badgeLabel.isHidden = true
            confidenceLabel.isHidden = true
            rationaleLabel.isHidden = true
            
        case .failed(let message):
            placeholderLabel.isHidden = false
            placeholderLabel.text = "AI recommendation unavailable: \(message)"
            badgeLabel.isHidden = true
            confidenceLabel.isHidden = true
            rationaleLabel.isHidden = true
            
        case .loaded(let recommendation):
            placeholderLabel.isHidden = true
            badgeLabel.isHidden = false
            confidenceLabel.isHidden = false
            rationaleLabel.isHidden = false
            
            badgeLabel.text = recommendation.action.rawValue
            switch recommendation.action {
            case .buy:
                badgeLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
                badgeLabel.textColor = .systemGreen
            case .hold:
                badgeLabel.backgroundColor = UIColor.systemGray5
                badgeLabel.textColor = .label
            case .sell:
                badgeLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
                badgeLabel.textColor = .systemRed
            }
            
            let confidencePercent = Int(recommendation.confidence * 100)
            confidenceLabel.text = "Confidence: \(confidencePercent)%"
            rationaleLabel.text = recommendation.rationale
        }
    }
}


