//
//  RecipeViewModel.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

@MainActor
final class RecipeListViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var state: RecipeListState = .initial
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchText = ""

    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let safariService: SafariServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol

    // MARK: - Internal Data
    private var allRecipes: [Recipe] = []

    // MARK: - Computed Properties
    var isLoaded: Bool {
        if case .loaded = state { return true }
        return false
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favoritesService.isFavorite(id)
    }
    
    func openInSafari(_ url: URL, in isPresented: Binding<Bool>, selectedURL: Binding<URL?>) {
        safariService.open(url: url, in: isPresented, selectedURL: selectedURL)
    }

    var displayedRecipes: [Recipe] {
        guard !searchText.isEmpty else {
            return filteredRecipes
        }

        return filteredRecipes.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }

    var uniqueCuisines: [String] {
        Array(Set(allRecipes.map { $0.cuisine })).sorted()
    }

    // MARK: - Init
    init(
        networkService: NetworkServiceProtocol,
        favoritesService: FavoritesServiceProtocol,
        imageLoaderService: ImageLoaderServiceProtocol,
        safariService: SafariServiceProtocol
    ) {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
    }

    // MARK: - Actions
    func loadRecipes() async {
        state = .loading

        do {
            let recipes = try await networkService.loadRecipes()
            allRecipes = recipes.recipes
            filteredRecipes = recipes.recipes
            state = .loaded(recipes.recipes)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func filterByCuisine(_ cuisine: String) {
        filteredRecipes = allRecipes.filter { $0.cuisine == cuisine }
    }

    func resetFilter() {
        filteredRecipes = allRecipes
    }
}
