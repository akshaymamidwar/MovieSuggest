//
//  MovieDetailViewModel.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation

enum MovieDetailViewState {
    case idle
    case loading
    case success(MovieDetailModel)
    case failure(Error)
}

class MovieDetailViewModel {

    // MARK: - Properties

    let movieID: Int
    let networkClientAPI: NetworkClientAPIProtocol
    var onStateChanged: (() -> Void)?
    private(set)var movieDetail: MovieDetailModel?

    private(set) var state: MovieDetailViewState = .idle {
        didSet {
            onStateChanged?()
        }
    }

    // MARK: - Initialization

    init(movieID: Int, networkClientAPI: NetworkClientAPIProtocol) {
        self.movieID = movieID
        self.networkClientAPI = networkClientAPI
    }

    // MARK: - Public Methods

    func fetchMovieDetail() {
        updateState(.loading)
        networkClientAPI.fetchMovieDetail(for: movieID) { result in
            switch result {
            case .success(let movieDetailModel):
                self.movieDetail = movieDetailModel
                self.updateState(.success(movieDetailModel))
            case .failure(let error):
                self.updateState(.failure(error))
            }
        }
    }

    // MARK: - Private Methods

    private func updateState(_ newState: MovieDetailViewState) {
        state = newState
    }
}
