//
//  ContentView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var container: DependencyContainer

    var body: some View {
        TabView {
            RecipeListView(container: container)
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }

            RecipeListView(container: container, showFavorites: true)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .environment(\.dependencyContainer, container)
    }
}

#Preview {
    ContentView(container: DependencyContainer())
}

