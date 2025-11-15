//
//  StockDetailNewsListCell.swift
//  StockDashboard
//
//  Created by Hossein Shirinabadi on 11/14/25.
//

import UIKit

class StockDetailNewsListCell: UICollectionViewCell {
    static let reuseIdentifier = "StockDetailNewsListCell"
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemFill
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var metaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var articleURL: URL?
    private var imageLoadTask: Task<Void, Never>?
    
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
        
        contentView.addSubview(container)
        
        container.addSubview(headlineLabel)
        container.addSubview(metaLabel)
        container.addSubview(thumbnailImageView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            thumbnailImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            thumbnailImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 120),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 120),
            
            headlineLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            headlineLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            headlineLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
            
            metaLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            metaLabel.trailingAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.leadingAnchor, constant: -12),
            metaLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            metaLabel.topAnchor.constraint(greaterThanOrEqualTo: headlineLabel.bottomAnchor, constant: 8)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
    }
    
    func configure(with article: NewsArticle) {
        headlineLabel.text = article.headline
        metaLabel.text = "\(article.source) · \(StockDashboardUtils.relativeTimeString(for: article.date))"
        articleURL = URL(string: article.url)
        loadImage(from: article.image)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoadTask?.cancel()
        imageLoadTask = nil
        thumbnailImageView.image = nil
        headlineLabel.text = nil
        metaLabel.text = nil
        articleURL = nil
    }
    
    @objc
    private func handleTap() {
        guard let url = articleURL else { return }
        UIApplication.shared.open(url)
    }
    
    private func loadImage(from urlString: String?) {
        imageLoadTask?.cancel()
        imageLoadTask = nil
        thumbnailImageView.image = nil

        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        imageLoadTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                try Task.checkCancellation()

                let (data, _) = try await URLSession.shared.data(from: url)
                
                try Task.checkCancellation()
                
                guard let image = UIImage(data: data) else { return }
                
                await MainActor.run {
                    if !Task.isCancelled {
                        self.thumbnailImageView.image = image
                    }
                }
            } catch is CancellationError {
                return
            } catch {
                // Ignore image loading errors for now
            }
        }
    }
}


