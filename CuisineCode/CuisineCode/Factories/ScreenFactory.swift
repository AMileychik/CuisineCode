//
//  ScreenFactory.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/18/25.
//

import SwiftUI

@MainActor
final class ScreenFactory {
    
    // MARK: - Dependencies
    private let viewModelFactory: ViewModelFactory

    // MARK: - Init
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    // MARK: - RecipeListView Screen Builder
    func makeRecipeListView(showFavorites: Bool = false) -> RecipeListView {
        let viewModel = viewModelFactory.makeRecipeListViewModel()
        return RecipeListView(
            viewModel: viewModel,
            screenFactory: self,
            showFavorites: showFavorites
        )
    }

    // MARK: - RecipeDetailView Screen Builder
    func makeRecipeDetailView(for recipe: Recipe) -> RecipeDetailView {
        let viewModel = viewModelFactory.makeRecipeDetailViewModel(for: recipe)
        return RecipeDetailView(viewModel: viewModel)
    }
}
