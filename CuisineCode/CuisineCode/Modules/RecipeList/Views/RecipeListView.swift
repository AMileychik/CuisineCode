//
//  RecipeListView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeListView: View {
    
    // MARK: - Dependencies
    let viewModelFactory: ViewModelFactory
    let showFavorites: Bool
    
    // MARK: - State
    @State private var selectedURL: URL?
    @State private var isShowingWebView: Bool = false
    @State private var tempName: String = ""
    @State private var showNamePrompt: Bool = false
    @FocusState private var isNameFieldFocused: Bool
    
    // MARK: - Storage
    @AppStorage("userName") private var userName: String = ""
    
    // MARK: - ViewModel
    @StateObject private var viewModel: RecipeListViewModel
    
    // MARK: - Init
    init(
        viewModel: RecipeListViewModel,
        viewModelFactory: ViewModelFactory,
        showFavorites: Bool = false
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.viewModelFactory = viewModelFactory
        self.showFavorites = showFavorites
    }
    
    // MARK: - Computed Properties
    private var displayedRecipes: [Recipe] {
        showFavorites
        ? viewModel.displayedRecipes.filter { viewModel.isFavorite($0.id) }
        : viewModel.displayedRecipes
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            recipeListContent
            if showNamePrompt {
                onboardingPrompt
            }
        }
    }
    
    // MARK: - Main Content
    private var recipeListContent: some View {
        NavigationStack {
            RecipeListContentView(showFavorites: showFavorites, 
                                  displayedRecipes: displayedRecipes,
                                  bannerURL: URLs.banner,
                                  viewModelFactory: viewModelFactory,
                                  onBannerTap: { viewModel.openInSafari(URLs.banner, in: $isShowingWebView, selectedURL: $selectedURL) },
                                  onRefresh: { await viewModel.loadRecipes() },
                                  viewModel: viewModel)
            .navigationBarTitleDisplayMode(.inline)
            .whiteNavigationBar()
            .toolbar { toolbarItems }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Texts.RecipeListView.searchRecipes
            )
            .task(id: isShowingWebView) {
                if !isShowingWebView && !viewModel.isLoaded {
                    await viewModel.loadRecipes()
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadRecipes()
                }
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
    }
    
    // MARK: - Onboarding Prompt
    private var onboardingPrompt: some View {
        OnboardingPromptView(
            isNameFieldFocused: _isNameFieldFocused,
            tempName: $tempName,
            showNamePrompt: $showNamePrompt,
            onSave: { userName = $0 }
        )
    }
    
    // MARK: - Toolbar
    private var toolbarItems: some ToolbarContent {
        RecipeToolbar(
            userName: userName,
            cuisines: viewModel.uniqueCuisines,
            onFilter: { viewModel.filterByCuisine($0) },
            onReset: { viewModel.resetFilter() }
        )
    }
}
