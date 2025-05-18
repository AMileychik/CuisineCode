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
        let factory = ViewModelFactory(container: container)

        return Group {
            RecipeListView(
                viewModel: factory.makeRecipeListViewModel(),
                viewModelFactory: factory,
                showFavorites: false
            )
            RecipeListView(
                viewModel: factory.makeRecipeListViewModel(),
                viewModelFactory: factory,
                showFavorites: true
            )
        }
    }
}
