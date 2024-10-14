//
//  MovieDetailViewController.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - Constants

    private let imageViewHeight: CGFloat = 300.0
    private let titleFontSize: CGFloat = 24.0
    private let fontSize: CGFloat = 16.0
    private let buttonHeight: CGFloat = 48.0
    private let cornerRadius: CGFloat = 8.0
    private let borderWidth: CGFloat = 2.0

    // MARK: - Properties

    private let viewModel: MovieDetailViewModel
    private let movieID: Int

    // MARK: - UI Elements

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityLabel = "Movie poster"
        imageView.image = UIImage(named: "Image")
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = CGSize(width: 0, height: Spacing.quarterX)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.accessibilityLabel = "Loading indicator"
        return indicator
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.errorColor
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "Error message"
        label.accessibilityHint = "An error occurred while loading movie details."
        return label
    }()

    private lazy var nameLabel: UILabel = createLabel(fontSize: titleFontSize, weight: .bold, numberOfLines: 0)
    private lazy var durationLabel: UILabel = createLabel(fontSize: fontSize)
    private lazy var descriptionLabel: UILabel = createLabel(fontSize: fontSize, numberOfLines: 0)
    private lazy var directorLabel: UILabel = createLabel(fontSize: fontSize)
    private lazy var genresLabel: UILabel = createLabel(fontSize: fontSize, numberOfLines: 0)
    private lazy var actorsLabel: UILabel = createLabel(fontSize: fontSize, numberOfLines: 0)

    private lazy var bookingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Book Now", for: .normal)
        button.backgroundColor = UIColor.primaryColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
        button.accessibilityLabel = "Book Now"
        button.accessibilityHint = "Tap to book tickets for this movie."
        return button
    }()

    // MARK: - Initializers

    init(movieID: Int) {
        self.movieID = movieID
        self.viewModel = MovieDetailViewModel(movieID: movieID, networkClientAPI: NetworkClientAPI.shared)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("MovieDetailViewController viewDidLoad")
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
        setupUI()
        setupConstraints()
        loadImage()
        bindViewModel()
        viewModel.fetchMovieDetail()
    }

    // MARK: - Setup Methods

    private func setupNavigationBar() {
        debugPrint("MovieDetailViewController setupNavigationBar")
        navigationItem.title = "Movie Details"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissButtonTapped)
        )
    }

    private func setupUI() {
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        view.addSubview(scrollView)
        view.addSubview(bookingButton)
        scrollView.addSubview(contentView)

        [imageView, nameLabel, durationLabel, descriptionLabel, directorLabel, genresLabel, actorsLabel].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            // Error Label
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.twoX),
            errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.twoX),

            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.twoX),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.twoX),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.twoX),
            scrollView.bottomAnchor.constraint(equalTo: bookingButton.topAnchor, constant: -Spacing.twoX),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Image View
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),

            // Name Label
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.oneX),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Duration Label
            durationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Spacing.oneX),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: Spacing.oneX),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Director Label
            directorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spacing.oneX),
            directorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            directorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Genres Label
            genresLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: Spacing.oneX),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Actors Label
            actorsLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Spacing.oneX),
            actorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actorsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.twoX),

            // Booking Button
            bookingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.twoX),
            bookingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.twoX),
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.twoX),
            bookingButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }

    // MARK: - Actions

    @objc
    private func dismissButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func bookingButtonTapped() {
        let webViewController = WebViewController(url: URL(string: "https://www.google.com/"))
        navigationController?.pushViewController(webViewController, animated: true)
    }

    // MARK: - Private Methods

    private func createLabel(fontSize: CGFloat, weight: UIFont.Weight = .regular, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.textColor
        return label
    }

    private func populateData() {
        guard let movie = viewModel.movieDetail else { return }
        nameLabel.attributedText = NSAttributedString.bold(movie.name, font: UIFont.systemFont(ofSize: titleFontSize))
        durationLabel.attributedText = NSAttributedString.attributedString(boldText: "Duration: ", normalText: movie.duration)
        descriptionLabel.attributedText = NSAttributedString.attributedString(boldText: "Description: ", normalText: movie.description)
        directorLabel.attributedText = NSAttributedString.attributedString(boldText: "Director: ", normalText: movie.director)
        genresLabel.attributedText = NSAttributedString.attributedString(boldText: "Genres: ", normalText: movie.genres.joined(separator: ", "))
        actorsLabel.attributedText = NSAttributedString.attributedString(boldText: "Actors: ", normalText: movie.actors.joined(separator: ", "))
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch self.viewModel.state {
                case .idle:
                    break // No action needed
                case .loading:
                    self.loadingIndicator.startAnimating()
                    self.scrollView.isHidden = true
                    self.bookingButton.isHidden = true
                    self.errorLabel.isHidden = true
                case .success:
                    self.loadingIndicator.stopAnimating()
                    self.scrollView.isHidden = false
                    self.bookingButton.isHidden = false
                    self.errorLabel.isHidden = true
                    self.populateData()
                case .failure(let error):
                    self.loadingIndicator.stopAnimating()
                    self.scrollView.isHidden = true
                    self.bookingButton.isHidden = true
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Failed to load data: \(error.localizedDescription)"
                }
            }
        }
    }

    private func loadImage() {
        NetworkClientAPI.shared.fetchImage(from: "https://picsum.photos/300/500") { result in
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
