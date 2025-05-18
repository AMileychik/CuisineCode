//
//  RecipeDetailContentView.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/18/25.
//

import SwiftUI

struct RecipeDetailContentView: View {
    
    @ObservedObject var viewModel: RecipeDetailViewModel
    @Binding var isShowingWebView: Bool
    @Binding var selectedURL: URL?
    
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
            url: viewModel.photoURLLarge,
            imageLoaderService: viewModel.imageLoaderService
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
                isShowingWebView: $isShowingWebView,
                selectedURL: $selectedURL,
                safariService: viewModel.safariService,
                title: Texts.RecipeDetailView.viewRecipe,
                gradient: [.blue, .purple],
                url: viewModel.sourceURL
            )
            ActionButton(
                isShowingWebView: $isShowingWebView,
                selectedURL: $selectedURL,
                safariService: viewModel.safariService,
                title: Texts.RecipeDetailView.watchOnYouTube,
                gradient: [.red, .orange],
                url: viewModel.youtubeURL
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
            safariService: viewModel.safariService
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
