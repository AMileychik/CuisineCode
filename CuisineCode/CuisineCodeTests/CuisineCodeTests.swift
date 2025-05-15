//
//  CuisineCodeTests.swift
//  CuisineCodeTests
//
//  Created by Alexander Mileychik on 4/30/25.
//

import XCTest
@testable import CuisineCode
import SwiftUI

final class RecipeListViewModelTests: XCTestCase {
    
    // MARK: - Mock Network Service
    final class MockNetworkService: NetworkServiceProtocol {
        var shouldReturnError = false
        var recipesToReturn: [Recipe] = []
        
        func loadRecipes() async throws -> RecipeResponse {
            if shouldReturnError {
                throw NetworkError.statusCode
            } else {
                return RecipeResponse(recipes: recipesToReturn)
            }
        }
    }
    
    // MARK: - Mock Favorites Service
    final class MockFavoritesService: FavoritesServiceProtocol {
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
    
    // MARK: - Mock Image Loader Service
    final class MockImageLoaderService: ImageLoaderServiceProtocol {
        func loadImage(from url: URL) async throws -> UIImage {
            return UIImage()
        }
    }
    
    // MARK: - Mock Safari Service
    final class MockSafariService: SafariServiceProtocol {
        func open(url: URL, in binding: Binding<Bool>, selectedURL: Binding<URL?>) {
            
        }
    }
    
    // MARK: - Successfully loaded recipes
    func testLoadRecipesSuccessUpdatesStateToLoaded() async {
        // Given
        let mockService = MockNetworkService()
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            if case .loaded(let recipes) = viewModel.state {
                XCTAssertEqual(recipes.count, 1)
                XCTAssertEqual(recipes.first?.name, "Pizza")
            } else {
                XCTFail("Expected state to be .loaded")
            }
        }
    }
    
    // MARK: - Error loading recipes
    func testLoadRecipesFailureUpdatesStateToError() async {
        // Given
        let mockService = MockNetworkService()
        mockService.shouldReturnError = true
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            if case .error(let message) = viewModel.state {
                XCTAssertFalse(message.isEmpty)
            } else {
                XCTFail("Expected state to be .error")
            }
        }
    }
    
    // MARK: - Filter by text
    func testFilterRecipesByNameAndCuisine() async {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let mockService = MockNetworkService()
        mockService.recipesToReturn = recipes
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        await MainActor.run {
            viewModel.searchText = "su"
        }
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.displayedRecipes.count, 1)
            XCTAssertEqual(viewModel.displayedRecipes.first?.name, "Sushi")
        }
    }
    
    // MARK: - Filter by cuisine
    func testFilterByCuisine() async {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Ramen", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let mockService = MockNetworkService()
        mockService.recipesToReturn = recipes
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        await viewModel.loadRecipes()
        
        // When
        await viewModel.filterByCuisine("Japanese")
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 1)
            XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Ramen")
        }
    }
    
    // MARK: - Resetting the filter returns all recipes
    func testResetFilterRestoresAllRecipes() async {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Spaghetti", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let mockService = MockNetworkService()
        mockService.recipesToReturn = recipes
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        await viewModel.loadRecipes()
        await viewModel.filterByCuisine("Italian")
        
        // Then (before reset)
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        }
        
        // When
        await viewModel.resetFilter()
        
        // Then (after reset)
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 2)
        }
    }
    
    // MARK: - Unique cuisines sorted and without duplicates
    func testUniqueCuisinesAreSortedAndUnique() async {
        // Given
        let recipes = [
            Recipe(id: UUID(), name: "Spaghetti", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Ramen", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let mockService = MockNetworkService()
        mockService.recipesToReturn = recipes
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.uniqueCuisines, ["Italian", "Japanese"])
        }
    }
    
    // MARK: - Initial state .initial
    func testInitialStateIsIdle() async {
        // Given
        let mockService = MockNetworkService()
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // Then
        await MainActor.run {
            if case .initial = viewModel.state {
                // OK
            } else {
                XCTFail("Expected initial state to be .initial")
            }
        }
    }
    
    // MARK: - Repeated calls to loadRecipes do not duplicate recipes
    func testMultipleLoadCallsResultInSameRecipes() async {
        // Given
        let mockService = MockNetworkService()
        let recipe = Recipe(id: UUID(), name: "Burger", cuisine: "American", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        mockService.recipesToReturn = [recipe]
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            if case .loaded(let recipes) = viewModel.state {
                XCTAssertEqual(recipes.count, 1)
                XCTAssertEqual(recipes.first?.name, "Burger")
            } else {
                XCTFail("Expected state to be .loaded after multiple calls")
            }
        }
    }
    
    // MARK: - Empty array of recipes
    func testEmptyRecipesUpdatesStateToLoadedWithEmptyArray() async {
        // Given
        let mockService = MockNetworkService()
        mockService.recipesToReturn = []
        let mockFavorites = MockFavoritesService()
        let mockImageLoaderService = MockImageLoaderService()
        let mockSafariService = MockSafariService()
        
        let viewModel = await RecipeListViewModel(networkService: mockService, favoriteService: mockFavorites, imageLoaderService: mockImageLoaderService, safariService: mockSafariService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            if case .loaded(let recipes) = viewModel.state {
                XCTAssertTrue(recipes.isEmpty)
            } else {
                XCTFail("Expected state to be .loaded with empty array")
            }
        }
    }
}
