//
//  ContentView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var recipeListViewModel: RecipeListViewModel
    
    let viewModelFactory = ViewModelFactory()
    
    var body: some View {
        TabView {
            RecipeListView(viewModel: recipeListViewModel, viewModelFactory: viewModelFactory)
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }
            
            RecipeListView(viewModel: recipeListViewModel, viewModelFactory: viewModelFactory, showFavorites: true)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

#Preview {
    ContentView(recipeListViewModel: ViewModelFactory().makeRecipeListViewModel())
}

