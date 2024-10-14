//
//  MovieCacheManager.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation

final class MovieCacheManager {

    // Singleton instance
    static let shared = MovieCacheManager()

    private let detailCache = NSCache<NSNumber, MovieDetailModel>()
    private let listCache = NSCache<NSString, NSArray>() // Cache for list of movies

    // Private initializer to enforce singleton pattern
    private init() {}

    // MARK: - Movie Detail Caching

    func cacheMovieDetail(_ movieDetail: MovieDetailModel) {
        debugPrint("MovieCacheManager cacheMovieDetail - setting cache for movieId \(movieDetail.id)")
        detailCache.setObject(movieDetail, forKey: NSNumber(value: movieDetail.id))
    }

    func cacheMovieDetails(_ movieDetails: [MovieDetailModel]) {
        for detail in movieDetails {
            cacheMovieDetail(detail)
        }
    }

    func getMovieDetail(for id: Int) -> MovieDetailModel? {
        debugPrint("MovieCacheManager getMovieDetail called")
        return detailCache.object(forKey: NSNumber(value: id))
    }

    // MARK: - Movie List Caching

    func cacheMovieList(_ movieList: [MovieModel], forKey key: String) {
        debugPrint("MovieCacheManager cacheMovieList - setting cache for movieList with key \(key)")
        listCache.setObject(movieList as NSArray, forKey: key as NSString)
    }

    func getMovieList(forKey key: String) -> [MovieModel]? {
        debugPrint("MovieCacheManager getMovieList called")
        return listCache.object(forKey: key as NSString) as? [MovieModel]
    }

    // MARK: - Other

    func clearCache() {
        debugPrint("MovieCacheManager clearCache called")
        detailCache.removeAllObjects()
        listCache.removeAllObjects()
    }
}
