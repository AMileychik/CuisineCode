//
//  RecipeDetailView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject var viewModel: RecipeDetailViewModel
    @State private var isShowingWebView: Bool = false
    @State private var selectedURL: URL?
    
    init(viewModel: RecipeDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group() {
            if viewModel.isDataLoaded {
                ScrollView() {
                    // ——— RECIPE IMAGE ———
                    RecipeImageView(
                        url: viewModel.photoURLLarge,
                        imageLoaderService: viewModel.imageLoaderService
                    )
                    // ——— RECIPE INFO ———
                    VStack(alignment: .leading) {
                        RecipeInfoView(
                            name: viewModel.name,
                            cuisine: viewModel.cuisine,
                            isFavorite: viewModel.isFavorite,
                            toggleFavorite: viewModel.toggleFavorite
                        )
                        // ——— VIEW RECIPE & WATCH ON YOUTUBE BUTTONS ———
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
                        .sheet(item: $selectedURL) { url in
                            SafariView(url: url)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        // ——— PARTNERS PROMO ———
                        FetchPartnersPromoView(partners: viewModel.partners,
                                               safariService: viewModel.safariService)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadData()
        }
    }
}






