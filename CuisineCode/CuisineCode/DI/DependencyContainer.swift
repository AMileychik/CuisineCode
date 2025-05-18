//
//  DependencyContainer.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/30/25.
//

import Foundation

protocol DependencyContainerProtocol {
    var networkService: NetworkServiceProtocol { get }
    var favoritesService: FavoritesServiceProtocol { get }
    var imageLoaderService: ImageLoaderServiceProtocol { get }
    var safariService: SafariServiceProtocol { get }
}

final class DependencyContainer: ObservableObject, DependencyContainerProtocol {
    
    let networkService: NetworkServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let safariService: SafariServiceProtocol
    
    init(networkService: NetworkServiceProtocol,
         favoritesService: FavoritesServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol,
         safariService: SafariServiceProtocol)
    {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
    }
}

extension DependencyContainer {
    
    static func makeDefault() -> DependencyContainer {
        DependencyContainer(
            networkService: NetworkService(),
            favoritesService: FavoritesService(),
            imageLoaderService: ImageLoaderService(),
            safariService: SafariService()
        )
    }
    
    static func makePreview() -> DependencyContainer {
        let mockNetworkService = PreviewMockNetworkService()
        let mockFavoritesService = PreviewMockFavoritesService(networkService: mockNetworkService)
        let mockImageLoaderService = PreviewMockImageLoaderService()
        let mockSafariService = PreviewMockSafariService()
        
        return DependencyContainer(
            networkService: mockNetworkService,
            favoritesService: mockFavoritesService,
            imageLoaderService: mockImageLoaderService,
            safariService: mockSafariService
        )
    }
}

