//
//  NetworkClientAPI.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation
import UIKit

protocol NetworkClientAPIProtocol {
    func fetchMoviesList(startIndex: Int, count: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void)
    func fetchMovieDetail(for id: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void)
}

class NetworkClientAPI: NetworkClientAPIProtocol {

    // MARK: - Endpoints

    private struct Endpoints {
        static let moviesByRank = "https://demoAPI.com/api/1/FEE/MoviesByRank"
        static let movieDetails = "https://demoAPI.com/api/1/FEE/MovieDetails"
    }

    // MARK: - Constants

    private struct Constants {
        static let authToken = "AUTH_TOKEN"
    }

    // Singleton instance
    static let shared = NetworkClientAPI()

    private init() {}

    // Mark: Dummy Data
    
    let dummyMovieList: [MovieModel] = [
        MovieModel(id: 1, rank: 1, name: "The Shawshank Redemption"),
        MovieModel(id: 2, rank: 2, name: "The Godfather"),
        MovieModel(id: 3, rank: 3, name: "The Dark Knight"),
        MovieModel(id: 4, rank: 4, name: "Pulp Fiction"),
        MovieModel(id: 5, rank: 5, name: "Forrest Gump"),
        MovieModel(id: 6, rank: 6, name: "Inception"),
        MovieModel(id: 7, rank: 7, name: "Fight Club"),
        MovieModel(id: 8, rank: 8, name: "The Matrix"),
        MovieModel(id: 9, rank: 9, name: "The Lord of the Rings: The Return of the King"),
        MovieModel(id: 10, rank: 10, name: "Star Wars: Episode V - The Empire Strikes Back")
    ]
    
    let dummyMovieDetails: [MovieDetailModel] = [
        MovieDetailModel(id: 1, name: "The Shawshank Redemption", duration: "2h 22m", description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", director: "Frank Darabont", genres: ["Drama"], actors: ["Tim Robbins", "Morgan Freeman"]),
        MovieDetailModel(id: 2, name: "The Godfather", duration: "2h 55m", description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", director: "Francis Ford Coppola", genres: ["Crime", "Drama"], actors: ["Marlon Brando", "Al Pacino"]),
        MovieDetailModel(id: 3, name: "The Dark Knight", duration: "2h 32m", description: "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham.", director: "Christopher Nolan", genres: ["Action", "Crime"], actors: ["Christian Bale", "Heath Ledger"]),
        MovieDetailModel(id: 4, name: "Pulp Fiction", duration: "2h 34m", description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", director: "Quentin Tarantino", genres: ["Crime", "Drama"], actors: ["John Travolta", "Samuel L. Jackson"]),
        MovieDetailModel(id: 5, name: "Schindler's List", duration: "3h 15m", description: "In German-occupied Poland during World War II, Oskar Schindler gradually becomes concerned for his Jewish workforce after witnessing their persecution by the Nazis.", director: "Steven Spielberg", genres: ["Biography", "Drama"], actors: ["Liam Neeson", "Ben Kingsley"]),
        MovieDetailModel(id: 6, name: "The Lord of the Rings: The Return of the King", duration: "3h 21m", description: "Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.", director: "Peter Jackson", genres: ["Action", "Adventure", "Drama"], actors: ["Elijah Wood", "Viggo Mortensen"]),
        MovieDetailModel(id: 7, name: "Fight Club", duration: "2h 19m", description: "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.", director: "David Fincher", genres: ["Drama"], actors: ["Brad Pitt", "Edward Norton"]),
        MovieDetailModel(id: 8, name: "Forrest Gump", duration: "2h 22m", description: "The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal, and other historical events unfold from the perspective of an Alabama man with an IQ of 75.", director: "Robert Zemeckis", genres: ["Drama", "Romance"], actors: ["Tom Hanks", "Robin Wright"]),
        MovieDetailModel(id: 9, name: "Inception", duration: "2h 28m", description: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", director: "Christopher Nolan", genres: ["Action", "Sci-Fi"], actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt"]),
        MovieDetailModel(id: 10, name: "The Matrix", duration: "2h 16m", description: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", director: "Lana Wachowski, Lilly Wachowski", genres: ["Action", "Sci-Fi"], actors: ["Keanu Reeves", "Laurence Fishburne"])
    ]

    // MARK: - Public Methods

    func fetchMoviesList(startIndex: Int, count: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        // Return dummy movie list
        completion(.success(dummyMovieList))
        
        // Commented API call as we are passing dummy data
        /**
        let cacheKey = "\(startIndex)_\(count)"

        if let cachedMovies = MovieCacheManager.shared.getMovieList(forKey: cacheKey) {
            debugPrint("NetworkClientAPI fetchMoviesList: Valid cache found, returning cached data for cacheKey ")
            completion(.success(cachedMovies))
            return
        }

        requestMoviesList(startIndex: startIndex, count: count) { [weak self] result in
            switch result {
            case .success(let movies):
                MovieCacheManager.shared.cacheMovieList(movies, forKey: cacheKey)
                self?.fetchMovieDetails(for: movies.map { $0.id }, completion: { _ in })
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
         */
    }

    func fetchMovieDetail(for id: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        completion(.success(dummyMovieDetails[id-1]))

        // Below code is useful in case of actual API
        /**
        if let cachedDetail = MovieCacheManager.shared.getMovieDetail(for: id) {
            debugPrint("NetworkClientAPI fetchMovieDetail: Valid cache found, returning cached data for id \(id)")
            completion(.success(cachedDetail))
            return
        }

        fetchMovieDetails(for: [id]) { result in
            switch result {
            case .success(let movieDetails):
                if let movieDetail = movieDetails.first {
                    MovieCacheManager.shared.cacheMovieDetail(movieDetail)
                    completion(.success(movieDetail))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No movie details found."])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
         */
    }

    // MARK: - Private Methods

    private func fetchMovieDetails(for ids: [Int], completion: @escaping (Result<[MovieDetailModel], Error>) -> Void) {
        guard var urlComponents = URLComponents(string: Endpoints.movieDetails) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URLComponents"])))
            return
        }

        // Query items
        let movieIdsQueryItems = ids.map { URLQueryItem(name: "movieIds", value: "\($0)") }
        let authTokenQueryItem = URLQueryItem(name: "authToken", value: Constants.authToken)

        urlComponents.queryItems = [authTokenQueryItem] + movieIdsQueryItems

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        debugPrint("NetworkClientAPI fetchMovieDetails: fetching data for \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                debugPrint("NetworkClientAPI fetchMovieDetails: error \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                debugPrint("NetworkClientAPI fetchMovieDetails: No data received")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            // Convert data to string for debug purpose
            if let dataString = String(data: data, encoding: .utf8) {
                debugPrint("NetworkClientAPI fetchMovieDetails: Data received: \(dataString)")
            } else {
                debugPrint("NetworkClientAPI fetchMovieDetails: Failed to convert data to string.")
            }
            do {
                let movieDetails = try JSONDecoder().decode([MovieDetailModel].self, from: data)
                MovieCacheManager.shared.cacheMovieDetails(movieDetails)
                completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func requestMoviesList(startIndex: Int, count: Int, completion: @escaping (Result<[MovieModel], Error>) -> Void) {
        var urlComponents = URLComponents(string: Endpoints.moviesByRank)!
        urlComponents.queryItems = [
            URLQueryItem(name: "authToken", value: Constants.authToken),
            URLQueryItem(name: "startRankIndex", value: "\(startIndex)"),
            URLQueryItem(name: "numMovies", value: "\(count)")
        ]

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        debugPrint("NetworkClientAPI requestMoviesList: fetching data for \(url.absoluteString)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            // Convert data to string for debug purpose
            if let dataString = String(data: data, encoding: .utf8) {
                debugPrint("NetworkClientAPI requestMoviesList: Data received: \(dataString)")
            } else {
                debugPrint("NetworkClientAPI requestMoviesList: Failed to convert data to string.")
            }

            do {
                let movies = try JSONDecoder().decode([MovieModel].self, from: data)
                completion(.success(movies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Extension to handle image-related functionalities in NetworkClientAPI
// This extension contains methods specifically for fetching images from URLs.
extension NetworkClientAPI {

    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image."])))
                return
            }

            completion(.success(image))
        }.resume()
    }
}
