//
//  RecipeListView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik  on 4/29/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @State private var searchText: String = ""
    @State private var tempName: String = ""
    @State private var showNamePrompt: Bool = false
    @State private var selectedURL: URL?
    @State private var isShowingWebView: Bool = false
    
    @AppStorage("userName") private var userName: String = ""
    @FocusState private var isNameFieldFocused: Bool
    @StateObject private var viewModel: RecipeListViewModel
    
    let favoritesService: FavoritesServiceProtocol
    let safariService: SafariServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let showFavorites: Bool
    
    private var displayedRecipes: [Recipe] {
        viewModel.displayedRecipes.filter {
            showFavorites == false || favoritesService.isFavorite($0.id) }
    }
    
    init(container: DependencyContainer, showFavorites: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: RecipeListViewModel(
                networkService: container.networkService,
                favoriteService: container.favoritesService
            )
        )
        self.favoritesService = container.favoritesService
        self.safariService = container.safariService
        self.imageLoaderService = container.imageLoaderService
        self.showFavorites = showFavorites
    }
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    switch viewModel.state {
                    case .initial, .loading:
                        ProgressView(Texts.RecipeListView.progressViewState)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error(let message):
                        Text("Error: \(message)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .loaded:
                        ScrollView {
                            VStack(spacing: 16) {
                                // ——— FETCH BANNER ———
                                if !showFavorites {
                                    FetchBannerView {
                                        if let url = viewModel.bannerURL {
                                            safariService.open(url: url, in: $isShowingWebView, selectedURL: $selectedURL)
                                        }
                                    }
                                    // ——— HEADER ———
                                    HeaderView(text: Texts.RecipeListView.recipeHeader)
                                }
                                // ——— ANIMATED FAVORITE HEADER ———
                                if showFavorites {
                                    AnimatedFavoriteHeader(title: Texts.RecipeListView.favoriteRecipesHeader)
                                }
                                // ——— RECIPE GRID ———
                                if displayedRecipes.isEmpty {
                                    Text(Texts.RecipeListView.emptyFavoritesList)
                                        .foregroundColor(.secondary)
                                        .padding()
                                } else {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(displayedRecipes) { recipe in
                                            NavigationLink(destination:
                                                            RecipeDetailView(
                                                                viewModel: .init(
                                                                    recipe: recipe,
                                                                    favoritesService: favoritesService,
                                                                    imageLoaderService: imageLoaderService,
                                                                    safariService: safariService
                                                                )
                                                            )
                                            ) {
                                                RecipeGrid(recipe: recipe)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .refreshable {
                            await viewModel.loadRecipes()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .whiteNavigationBar()
                // ——— TOOLBAR ITEMS ———
                .toolbar {
                    RecipeToolbar(
                        userName: userName,
                        cuisines: viewModel.uniqueCuisines,
                        onFilter: { viewModel.filterByCuisine($0) },
                        onReset: { viewModel.resetFilter() }
                    )
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Texts.RecipeListView.searchRecipes)
                .task(id: isShowingWebView) {
                    if !isShowingWebView && !viewModel.isLoaded {
                        await viewModel.loadRecipes()
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.loadRecipes()
                    }
                    // ——— ONBOARDING CHECK ———
                    if userName.isEmpty {
                        showNamePrompt = true
                    }
                }
                .sheet(isPresented: $isShowingWebView) {
                    if let url = selectedURL {
                        SafariView(url: url)
                    }
                }
            }
            // ——— ONBOARDING VIEW ———
            if showNamePrompt {
                OnboardingView(
                    isNameFieldFocused: _isNameFieldFocused, 
                    tempName: $tempName,
                    showNamePrompt: $showNamePrompt,
                    onSave: { userName = $0 }
                )
            }
        }
    }
}

