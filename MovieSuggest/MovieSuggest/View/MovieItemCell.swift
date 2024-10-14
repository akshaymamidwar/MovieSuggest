//
//  MovieItemCell.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation
import UIKit

class MovieItemCell: UICollectionViewCell {

    // MARK: - Constant

    let cornerRadius: CGFloat = 16.0
    let rankLabelCornerRadius: CGFloat = 8.0
    let borderWidth: CGFloat = 1.0

    // MARK: - UI Elements

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityLabel = "Movie poster"
        imageView.image = UIImage(named: "Image")
        return imageView
    }()

    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = rankLabelCornerRadius
        label.clipsToBounds = true
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "Movie rank"
        return label
    }()

    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = UIColor.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "Movie name"
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
        setupAppearance()
        loadImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with movie: MovieModel) {
        rankLabel.text = String(movie.rank)
        movieNameLabel.text = movie.name
    }

    // MARK: - Private Methods

    private func setupViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(rankLabel)
        contentView.addSubview(movieNameLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for imageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Constraints for rankLabel
            rankLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.oneX),
            rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.oneX),
            rankLabel.widthAnchor.constraint(equalToConstant: Spacing.sixX),
            rankLabel.heightAnchor.constraint(equalToConstant: Spacing.threeX),
            
            // Constraints for movieNameLabel
            movieNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.oneX),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.oneX),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.oneX),
            movieNameLabel.heightAnchor.constraint(equalToConstant: Spacing.sixX),
            movieNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.twoX)
        ])
    }

    private func setupAppearance() {
        backgroundColor = UIColor.cellBackgroundColor
        contentView.backgroundColor = UIColor.cellBackgroundColor
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.borderWidth = borderWidth
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: Spacing.quarterX)
        contentView.layer.shadowRadius = cornerRadius
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    }

    private func loadImage() {
        NetworkClientAPI.shared.fetchImage(from: "https://picsum.photos/200?random=1") { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    UIView.transition(
                        with: self.imageView,
                        duration: 0.75,
                        options: .transitionCurlUp,
                        animations: { self.imageView.image = image },
                        completion: nil)
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
}
