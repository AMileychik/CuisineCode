//
//  AppFactory.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/14/25.
//

import SwiftUI

@MainActor
final class ViewModelFactory {
    
    private let container: DependencyContainer

    init(container: DependencyContainer = .makeDefault()) {
        self.container = container
    }

    func makeRecipeListViewModel() -> RecipeListViewModel {
        RecipeListViewModel(
            networkService: container.networkService,
            favoriteService: container.favoritesService,
            imageLoaderService: container.imageLoaderService,
            safariService: container.safariService
        )
    }

    func makeRecipeDetailViewModel(for recipe: Recipe, favoritesService: FavoritesServiceProtocol) -> RecipeDetailViewModel {
        RecipeDetailViewModel(
            recipe: recipe,
            favoritesService: favoritesService,
            imageLoaderService: container.imageLoaderService,
            safariService: container.safariService
        )
    }
}
