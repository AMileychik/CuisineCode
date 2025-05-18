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
            .mock,
            Recipe(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                name: "Sushi Roll",
                cuisine: "Japanese",
                photoURLLarge: URL(string: "https://example.com/large-sushi.jpg"),
                photoURLSmall: URL(string: "https://example.com/small-sushi.jpg"),
                sourceURL: URL(string: "https://example.com/sushi-recipe"),
                youtubeURL: URL(string: "https://youtube.com/sushi")
            ),
            Recipe(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                name: "Tacos",
                cuisine: "Mexican",
                photoURLLarge: URL(string: "https://example.com/large-tacos.jpg"),
                photoURLSmall: URL(string: "https://example.com/small-tacos.jpg"),
                sourceURL: URL(string: "https://example.com/tacos-recipe"),
                youtubeURL: URL(string: "https://youtube.com/tacos")
            )
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
}

// MARK: - PreviewMockSafariService
final class PreviewMockSafariService: SafariServiceProtocol {
    func open(url: URL, in isPresented: Binding<Bool>, selectedURL: Binding<URL?>) {
        selectedURL.wrappedValue = url
        isPresented.wrappedValue = true
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
}

// MARK: - TestMockSafariService
final class TestMockSafariService: SafariServiceProtocol {
    func open(url: URL, in binding: Binding<Bool>, selectedURL: Binding<URL?>) {
        
    }
}

// MARK: - TestMockImageLoaderService
final class TestMockImageLoaderService: ImageLoaderServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage {
        return UIImage()
    }
}


