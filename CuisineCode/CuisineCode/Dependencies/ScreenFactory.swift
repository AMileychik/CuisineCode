//
//  ScreenFactory.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/18/25.
//

import SwiftUI

@MainActor
final class ScreenFactory {
    
    private let viewModelFactory: ViewModelFactory

    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func makeRecipeListView(showFavorites: Bool = false) -> some View {
        let viewModel = viewModelFactory.makeRecipeListViewModel()
        return RecipeListView(
            viewModel: viewModel,
            viewModelFactory: viewModelFactory,
            showFavorites: showFavorites
        )
    }

    func makeRecipeDetailView(for recipe: Recipe) -> some View {
        let viewModel = viewModelFactory.makeRecipeDetailViewModel(for: recipe)
        return RecipeDetailView(viewModel: viewModel)
    }
}


