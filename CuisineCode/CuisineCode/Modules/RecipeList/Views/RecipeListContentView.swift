//
//  RecipeListContentView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/16/25.
//

import SwiftUI

struct RecipeListContentView: View {
    
    let state: RecipeListState
    let showFavorites: Bool
    let displayedRecipes: [Recipe]
    let onBannerTap: () -> Void
    let onRefresh: () async -> Void
    let onRecipeSelect: (Recipe) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        VStack {
            switch state {
            case .initial, .loading:
                loadingView
                
            case .error(let message):
                ErrorStateView(message: message)
                
            case .loaded:
                loadedView
            }
        }
    }
    
    // MARK: - Loading Indicator View
    private var loadingView: some View {
        ProgressView(Texts.RecipeListView.progressViewState)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Loaded View
    private var loadedView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !showFavorites {
                    bannerView
                    recipeHeader
                }
                
                if showFavorites {
                    favoriteHeader
                }
                
                if displayedRecipes.isEmpty {
                    emptyFavoritesView
                } else {
                    recipeGrid
                }
            }
        }
        .refreshable {
            await onRefresh()
        }
    }
    
    // MARK: - Banner module
    private var bannerView: some View {
        FetchBannerView {
            onBannerTap()
        }
    }
    
    // MARK: - Recipe Header
    private var recipeHeader: some View {
        HeaderView(text: Texts.RecipeListView.recipeHeader)
    }
    
    // MARK: - Favorite Header
    private var favoriteHeader: some View {
        AnimatedFavoriteHeader(title: Texts.RecipeListView.favoriteRecipesHeader)
    }
    
    // MARK: - Empty Favorites View
    private var emptyFavoritesView: some View {
        Text(Texts.RecipeListView.emptyFavoritesList)
            .foregroundColor(.secondary)
            .padding()
    }
    
    // MARK: - Recipe Grid
    private var recipeGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(displayedRecipes) { recipe in
                Button {
                    onRecipeSelect(recipe)
                } label: {
                    RecipeGrid(recipe: recipe)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}


