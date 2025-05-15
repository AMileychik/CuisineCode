//
//  DependencyContainer.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/30/25.
//

import Foundation

final class DependencyContainer: ObservableObject {
    
    let networkService: NetworkServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let safariService: SafariServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol,
        favoritesService: FavoritesServiceProtocol,
        imageLoaderService: ImageLoaderServiceProtocol,
        safariService: SafariServiceProtocol
    ) {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
    }
    
    static func makeDefault() -> DependencyContainer {
        DependencyContainer(
            networkService: NetworkService(),
            favoritesService: FavoritesService(),
            imageLoaderService: ImageLoaderService(),
            safariService: SafariService()
        )
    }
}


