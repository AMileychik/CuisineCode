//
//  ViewModelFactory.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/14/25.
//

import SwiftUI

@MainActor
final class ViewModelFactory {
    
    // MARK: - Dependencies
    private let container: DependencyContainerProtocol
    
    init(container: DependencyContainerProtocol = DependencyContainer.makeDefault()) {
        self.container = container
    }
    
    func makeRecipeListViewModel() -> RecipeListViewModel {
        RecipeListViewModel(
            networkService: container.networkService,
            favoritesService: container.favoritesService,
            imageLoaderService: container.imageLoaderService
        )
    }
    
    func makeRecipeDetailViewModel(for recipe: Recipe) -> RecipeDetailViewModel {
        RecipeDetailViewModel(
            recipe: recipe,
            favoritesService: container.favoritesService,
            imageLoaderService: container.imageLoaderService
        )
    }
}
