//
//  StockDetailInfoCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailInfoCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStackView: UIStackView = {
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
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            infoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(title: String, infoItems: [(title: String, value: String)]) {
        titleLabel.text = title
        
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        infoItems.forEach { item in
            let rowView = createInfoRow(title: item.title, value: item.value)
            infoStackView.addArrangedSubview(rowView)
        }
    }
    
    private func createInfoRow(title: String, value: String) -> UIView {
        let rowView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -4),
            
            valueLabel.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: rowView.bottomAnchor, constant: -4),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8)
        ])
        
        return rowView
    }
}
