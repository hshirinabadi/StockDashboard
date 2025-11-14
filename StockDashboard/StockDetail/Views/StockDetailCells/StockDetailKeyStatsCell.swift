//
//  StockDetailKeyStatsCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailKeyStatsCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailKeyStatsCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsGridView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(statsGridView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statsGridView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            statsGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsGridView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(title: String, stats: [(label: String, value: String)]) {
        titleLabel.text = title
        
        statsGridView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var currentRow: UIStackView?
        
        for (index, stat) in stats.enumerated() {
            if index % 2 == 0 {
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.distribution = .fillEqually
                currentRow?.spacing = 16
                statsGridView.addArrangedSubview(currentRow!)
            }
            
            let statView = createStatView(label: stat.label, value: stat.value)
            currentRow?.addArrangedSubview(statView)
        }
    }
    
    private func createStatView(label: String, value: String) -> UIView {
        let containerView = UIView()
        
        let labelText = UILabel()
        labelText.text = label
        labelText.font = UIFont.systemFont(ofSize: 14)
        labelText.textColor = .secondaryLabel
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        let valueText = UILabel()
        valueText.text = value
        valueText.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueText.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(labelText)
        containerView.addSubview(valueText)
        
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            labelText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            valueText.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 2),
            valueText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
        
        return containerView
    }
}
