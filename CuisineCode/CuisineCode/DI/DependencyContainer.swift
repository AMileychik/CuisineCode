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
}

final class DependencyContainer: DependencyContainerProtocol {
    
    let networkService: NetworkServiceProtocol
    let favoritesService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    
    init(networkService: NetworkServiceProtocol,
         favoritesService: FavoritesServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol)
    {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
    }
}

extension DependencyContainer {
    
    static func makeDefault() -> DependencyContainerProtocol {
        DependencyContainer(
            networkService: NetworkService(),
            favoritesService: FavoritesService(),
            imageLoaderService: ImageLoaderService()
        )
    }
    
    static func makePreview() -> DependencyContainerProtocol {
        let mockNetworkService = PreviewMockNetworkService()
        let mockFavoritesService = PreviewMockFavoritesService(networkService: mockNetworkService)
        let mockImageLoaderService = PreviewMockImageLoaderService()
        
        return DependencyContainer(
            networkService: mockNetworkService,
            favoritesService: mockFavoritesService,
            imageLoaderService: mockImageLoaderService
        )
    }
}
