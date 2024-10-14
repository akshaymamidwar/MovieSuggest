//
//  MovieListViewController.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Components

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.accessibilityLabel = "Loading indicator"
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Spacing.twoX, left: Spacing.twoX, bottom: Spacing.twoX, right: Spacing.twoX)
        layout.minimumLineSpacing = Spacing.twoX
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieItemCell.self, forCellWithReuseIdentifier: "MovieItemCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityLabel = "Movies collection"
        collectionView.accessibilityHint = "Browse through a list of movies."
        return collectionView
    }()
    
    var viewModel = MovieListViewModel(networkClientAPI: NetworkClientAPI.shared)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        debugPrint("ViewController viewDidLoad")
        super.viewDidLoad()
        self.navigationItem.title = "Discovery"
        self.navigationController?.navigationBar.barTintColor = UIColor.primaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        setupViewHierarchy()
        setupConstraints()
        bindViewModel()
        viewModel.fetchMovies()
    }
    
    override func viewWillLayoutSubviews() {
        debugPrint("ViewController viewWillLayoutSubviews")
        super.viewWillLayoutSubviews()
        updateCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refetch movies only if the state is not success
        if case .failure = viewModel.state {
            viewModel.fetchMovies()
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupViewHierarchy() {
        view.addSubview(loadingIndicator)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = self.view.safeAreaLayoutGuide.layoutFrame.width - Spacing.fiveX
            let height = width * 0.6
            layout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch self.viewModel.state {
                case .idle:
                    break
                case .loading:
                    self.loadingIndicator.startAnimating()
                    self.loadingIndicator.isHidden = false
                    self.collectionView.isHidden = true
                    
                case .success(_):
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                    
                case .failure(_):
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.collectionView.isHidden = true
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItemCell", for: indexPath) as? MovieItemCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        cell.accessibilityLabel = "Movie poster for \(movie.name), ranked \(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.item]
        let movieDetailVC = MovieDetailViewController(movieID: selectedMovie.id)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
