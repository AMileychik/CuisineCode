//
//  RecipeListView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeListView: View {
    
    // MARK: - Dependencies
    private let screenFactory: ScreenFactory
    private let showFavorites: Bool
    
    // MARK: - State
    @State private var selectedRecipe: Recipe?
    @State private var tempName: String = ""
    @State private var showNamePrompt = false
    @AppStorage("userName") private var userName: String = ""
    @FocusState private var isNameFieldFocused: Bool
    
    // MARK: - ViewModel
    @ObservedObject private var viewModel: RecipeListViewModel
    
    // MARK: - Init
    init(
        viewModel: RecipeListViewModel,
        screenFactory: ScreenFactory,
        showFavorites: Bool = false
    ) {
        self.viewModel = viewModel
        self.screenFactory = screenFactory
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
    
    // MARK: - Main Content Layer
    private var recipeListContent: some View {
        NavigationStack {
            RecipeListContentView(
                state: viewModel.state,
                showFavorites: showFavorites,
                displayedRecipes: displayedRecipes,
                onBannerTap: {
                    viewModel.openInSafari(URLs.banner)
                },
                onRefresh: { await viewModel.loadRecipes() },
                onRecipeSelect: { recipe in
                    selectedRecipe = recipe
                }
            )
            .navigationDestination(item: $selectedRecipe) { recipe in
                screenFactory.makeRecipeDetailView(for: recipe)
            }
            .onChange(of: selectedRecipe) { oldValue, newValue in
                if newValue == nil && showFavorites {
                    viewModel.updateFavorites()
                }
            }
            .sheet(item: $viewModel.selectedURL) { url in
                SafariView(url: url)
            }
            .navigationBarTitleDisplayMode(.inline)
            .whiteNavigationBar()
            .toolbar { toolbarItems }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Texts.RecipeListView.searchRecipes
            )
        }
        .task {
            await viewModel.loadRecipes()
            
            if userName.isEmpty {
                showNamePrompt = true
            }
        }
    }
    
    // MARK: - Onboarding
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
