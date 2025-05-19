//
//  RootView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/18/25.
//

import SwiftUI

struct RootView: View {
    
    let factory: ScreenFactory
    
    var body: some View {
        TabView {
            factory.makeRecipeListView()
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }
            
            factory.makeRecipeListView(showFavorites: true)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

