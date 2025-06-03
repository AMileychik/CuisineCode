//
//  RecipeListView_Previews.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let container = DependencyContainer.makePreview()
        let viewModelFactory = ViewModelFactory(container: container)
        let screenFactory = ScreenFactory(viewModelFactory: viewModelFactory)

        return Group {
            
            RecipeListView(
                viewModel: viewModelFactory.makeRecipeListViewModel(),
                screenFactory: screenFactory,
                showFavorites: false
            )
            .environment(\.imageLoaderService, container.imageLoaderService)
            
            RecipeListView(
                viewModel: viewModelFactory.makeRecipeListViewModel(),
                screenFactory: screenFactory,
                showFavorites: true
            )
            .environment(\.imageLoaderService, container.imageLoaderService)
        }
    }
}
