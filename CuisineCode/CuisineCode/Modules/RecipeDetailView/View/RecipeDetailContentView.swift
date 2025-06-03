//
//  RecipeDetailContentView.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/18/25.
//

import SwiftUI

struct RecipeDetailContentView: View {
    
    @ObservedObject var viewModel: RecipeDetailViewModel
        
    var body: some View {
        if viewModel.isDataLoaded {
            ScrollView {
                recipeImageView
                recipeInfoView
                actionButtons
                partnersPromoView
            }
        } else {
            loadingView
        }
    }
    
    // MARK: - Recipe Image View
    private var recipeImageView: some View {
        RecipeImageView(
            url: viewModel.photoURLLarge
        )
    }
    
    // MARK: - Recipe Info View
    private var recipeInfoView: some View {
        RecipeInfoView(
            name: viewModel.name,
            cuisine: viewModel.cuisine,
            isFavorite: viewModel.isFavorite,
            toggleFavorite: viewModel.toggleFavorite
        )
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 16) {
            ActionButton(
                title: Texts.RecipeDetailView.viewRecipe,
                gradient: [.blue, .purple],
                onTap: {
                    if let url = viewModel.sourceURL {
                        viewModel.openInSafari(url)
                    }
                }
            )
            ActionButton(
                title: Texts.RecipeDetailView.watchOnYouTube,
                gradient: [.red, .orange],
                onTap: {
                    if let url = viewModel.youtubeURL {
                        viewModel.openInSafari(url)
                    }
                }
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
    }
    
    // MARK: - Partners Promo View
    private var partnersPromoView: some View {
        FetchPartnersPromoView(
            partners: viewModel.partners,
            onTap: { url in
                if let url = url {
                    viewModel.openInSafari(url)
                }
            }
        )
        .padding(.bottom)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}
