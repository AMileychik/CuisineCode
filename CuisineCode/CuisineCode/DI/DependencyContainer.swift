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
        networkService: NetworkServiceProtocol = NetworkService(),
        favoritesService: FavoritesServiceProtocol = FavoritesService(),
        imageLoaderService: ImageLoaderServiceProtocol = ImageLoaderService(),
        safariService: SafariServiceProtocol = SafariService()
    ) {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
    }
}



