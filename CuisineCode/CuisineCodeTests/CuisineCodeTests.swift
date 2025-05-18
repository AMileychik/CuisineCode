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
    
    private lazy var favoritesService = TestMockFavoritesService()
    private lazy var imageLoaderService = TestMockImageLoaderService()
    private lazy var safariService = PreviewMockSafariService()
    
    private func makeViewModel(with networkService: TestMockNetworkService) async -> RecipeListViewModel {
        await RecipeListViewModel(
            networkService: networkService,
            favoritesService: favoritesService,
            imageLoaderService: imageLoaderService,
            safariService: safariService
        )
    }
    
    // MARK: - Successful loading updates state to loaded
    func testLoadRecipesSuccessUpdatesStateToLoaded() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Pizza", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await makeViewModel(with: mockService)
        
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
    
    // MARK: - Error on loading updates state to error
    func testLoadRecipesFailureUpdatesStateToError() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.shouldReturnError = true
        
        let viewModel = await makeViewModel(with: mockService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            if case .error(let message) = viewModel.state {
                XCTAssertFalse(message.isEmpty, "Error message should not be empty")
            } else {
                XCTFail("Expected state to be .error")
            }
        }
    }
    
    // MARK: - Filter recipes by name and cuisine
    func testFilterRecipesByNameAndCuisine() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Sushi", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await makeViewModel(with: mockService)
        
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
    
    // MARK: - Filter recipes by cuisine only
    func testFilterByCuisine() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Ramen", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await makeViewModel(with: mockService)
        
        // When
        await viewModel.loadRecipes()
        await viewModel.filterByCuisine("Japanese")
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 1)
            XCTAssertEqual(viewModel.filteredRecipes.first?.name, "Ramen")
        }
    }
    
    // MARK: - Reset filter returns all recipes
    func testResetFilterRestoresAllRecipes() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Spaghetti", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Kasha", cuisine: "Russian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await makeViewModel(with: mockService)
        
        // When
        await viewModel.loadRecipes()
        await viewModel.filterByCuisine("Italian")
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 1)
        }
        
        // When
        await viewModel.resetFilter()
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.filteredRecipes.count, 2)
        }
    }
    
    // MARK: - Unique cuisines are sorted and unique
    func testUniqueCuisinesAreSortedAndUnique() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = [
            Recipe(id: UUID(), name: "Spaghetti", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(id: UUID(), name: "Ramen", cuisine: "Japanese", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await makeViewModel(with: mockService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.uniqueCuisines, ["Italian", "Japanese"])
        }
    }
    
    // MARK: - Initial state is idle
    func testInitialStateIsIdle() async {
        // Given
        let mockService = TestMockNetworkService()
        
        // When
        let viewModel = await makeViewModel(with: mockService)
        
        // Then
        await MainActor.run {
            if case .initial = viewModel.state {
                // OK
            } else {
                XCTFail("Expected initial state to be .initial")
            }
        }
    }
    
    // MARK: - Multiple load calls result in same recipes (no duplication)
    func testMultipleLoadCallsResultInSameRecipes() async {
        // Given
        let mockService = TestMockNetworkService()
        let recipe = Recipe(id: UUID(), name: "Burger", cuisine: "American", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        mockService.recipesToReturn = [recipe]
        let viewModel = await makeViewModel(with: mockService)
        
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
    
    // MARK: - Empty recipes update state to loaded with empty array
    func testEmptyRecipesUpdatesStateToLoadedWithEmptyArray() async {
        // Given
        let mockService = TestMockNetworkService()
        mockService.recipesToReturn = []
        let viewModel = await makeViewModel(with: mockService)
        
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





