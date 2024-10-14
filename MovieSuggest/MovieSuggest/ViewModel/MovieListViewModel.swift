//
//  MovieListViewModel.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation

enum MovieListViewState {
    case idle
    case loading
    case success([MovieModel])
    case failure(Error)
}

class MovieListViewModel {

    // MARK: - Properties

    let startIndex = 1
    let count = 10
    let networkClientAPI: NetworkClientAPIProtocol
    private(set) var movies: [MovieModel] = []

    var onStateChanged: (() -> Void)?

    // The current state of the view model
    private(set) var state: MovieListViewState = .idle {
        didSet {
            // Notify when state changes
            onStateChanged?()
        }
    }
   
    // MARK: - Properties

    init(networkClientAPI: NetworkClientAPIProtocol) {
        self.networkClientAPI = networkClientAPI
    }

    // MARK: - Public Methods

    func fetchMovies() {
        updateState(.loading)
        networkClientAPI.fetchMoviesList(startIndex: startIndex, count: count) { result in
            switch result {
            case .success(let moviewModels):
                self.movies = moviewModels
                self.updateState(.success(moviewModels))
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                self.updateState(.failure(error))
            }
        }
    }

    // MARK: - Private Methods

    private func updateState(_ newState: MovieListViewState) {
        state = newState
    }
}
