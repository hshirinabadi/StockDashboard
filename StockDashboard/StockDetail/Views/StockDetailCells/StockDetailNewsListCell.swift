//
//  StockDetailNewsListCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailNewsListCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailNewsListCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var imageTasks: [UIImageView: URLSessionDataTask] = [:]
    
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
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with article: NewsArticle) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let row = createRow(for: article)
        stackView.addArrangedSubview(row)
    }
    
    private func createRow(for article: NewsArticle) -> UIView {
        let container = UIControl()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 14
        container.clipsToBounds = true
        
        let thumbnailImageView = UIImageView()
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .tertiarySystemFill
        
        let headlineLabel = UILabel()
        headlineLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        headlineLabel.numberOfLines = 3
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.text = article.headline
        
        let metaLabel = UILabel()
        metaLabel.font = UIFont.systemFont(ofSize: 13)
        metaLabel.textColor = .secondaryLabel
        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        metaLabel.text = "\(article.source) · \(relativeTimeString(for: article.date))"
        
        container.addSubview(headlineLabel)
        container.addSubview(metaLabel)
        container.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            
            headlineLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            headlineLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            headlineLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -14),
            
            metaLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            metaLabel.trailingAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.leadingAnchor, constant: -14),
            metaLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
            metaLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor, constant: 6),
            
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
        if let urlString = article.image, let url = URL(string: urlString) {
            loadImage(from: url, into: thumbnailImageView)
        } else {
            thumbnailImageView.image = nil
        }
        
        container.addAction(UIAction { _ in
            if let url = URL(string: article.url) {
                UIApplication.shared.open(url)
            }
        }, for: .touchUpInside)
        
        return container
    }
    
    private func relativeTimeString(for date: Date) -> String {
        let now = Date()
        let seconds = Int(now.timeIntervalSince(date))
        
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86_400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        imageTasks[imageView]?.cancel()
        imageView.image = nil
        
        let task = URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, _, _ in
            guard let data = data, let image = UIImage(data: data), let imageView = imageView else { return }
            
            DispatchQueue.main.async {
                imageView.image = image
            }
            
            self?.imageTasks[imageView] = nil
        }
        
        imageTasks[imageView] = task
        task.resume()
    }
}


