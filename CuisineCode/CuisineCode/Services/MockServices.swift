//
//  MockServices.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/15/25.
//

import SwiftUI

// MARK: - PreviewMockServices

// MARK: - PreviewMockNetworkService
final class PreviewMockNetworkService: NetworkServiceProtocol {
    
    func loadRecipes() async throws -> RecipeResponse {
        let recipes: [Recipe] = [
            .mock
        ]
        
        return RecipeResponse(recipes: recipes)
    }
}

// MARK: - PreviewMockFavoritesService
final class PreviewMockFavoritesService: FavoritesServiceProtocol {
       
    private let networkService: NetworkServiceProtocol
    var favoriteIDs: Set<String> = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        Task {
            await loadInitialFavorites()
        }
    }
    
    private func loadInitialFavorites() async {
        if let recipes = try? await networkService.loadRecipes().recipes {
            favoriteIDs = Set(recipes.map { $0.id.uuidString })
        }
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favoriteIDs.contains(id.uuidString)
    }
    
    func toggleFavorite(_ id: UUID) {
        let idString = id.uuidString
        if favoriteIDs.contains(idString) {
            favoriteIDs.remove(idString)
        } else {
            favoriteIDs.insert(idString)
        }
    }
    
    func fetchFavoriteIDs() -> Set<UUID> {
        Set(favoriteIDs.compactMap {UUID(uuidString: $0)})
    }
}

// MARK: - PreviewMockImageLoaderService
final class PreviewMockImageLoaderService: ImageLoaderServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage {
        UIImage(named: "logo") ?? UIImage()
    }
}

// MARK: - TestMockServices

// MARK: - TestMockNetworkService
final class TestMockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var recipesToReturn: [Recipe] = []
    
    func loadRecipes() async throws -> RecipeResponse {
        if shouldReturnError {
            throw NetworkError.statusCode
        }
        return RecipeResponse(recipes: recipesToReturn)
    }
}

// MARK: - TestMockFavoritesService
final class TestMockFavoritesService: FavoritesServiceProtocol {
    
    var favoriteIDs: Set<String> = []
    
    func isFavorite(_ id: UUID) -> Bool {
        favoriteIDs.contains(id.uuidString)
    }
    
    func toggleFavorite(_ id: UUID) {
        let idString = id.uuidString
        if favoriteIDs.contains(idString) {
            favoriteIDs.remove(idString)
        } else {
            favoriteIDs.insert(idString)
        }
    }
    
    func fetchFavoriteIDs() -> Set<UUID> {
        Set(favoriteIDs.compactMap {UUID(uuidString: $0)})
    }
}

// MARK: - TestMockImageLoaderService
final class TestMockImageLoaderService: ImageLoaderServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage {
        return UIImage()
    }
}


