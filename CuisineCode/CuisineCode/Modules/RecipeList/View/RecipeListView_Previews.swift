//
//  RecipeListView_Previews.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(container: DependencyContainer(), showFavorites: false)
        RecipeListView(container: DependencyContainer(), showFavorites: true)
    }
}

