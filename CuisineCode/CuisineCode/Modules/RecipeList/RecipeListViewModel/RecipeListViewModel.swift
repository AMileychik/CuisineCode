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
    @Published var favoriteIDs: Set<UUID> = []
    @Published var searchText = ""
    @Published var selectedURL: URL? = nil

    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol

    // MARK: - Internal Data
    private var allRecipes: [Recipe] = []

    // MARK: - Computed Properties
    var isLoaded: Bool {
        if case .loaded = state { return true }
        return false
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
        imageLoaderService: ImageLoaderServiceProtocol
    ) {
        self.networkService = networkService
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
    }

    // MARK: - Actions
    func loadRecipes() async {
        state = .loading

        do {
            let recipes = try await networkService.loadRecipes()
            if Task.isCancelled { return }
            allRecipes = recipes.recipes
            filteredRecipes = recipes.recipes
            state = .loaded(recipes.recipes)
        } catch {
            if Task.isCancelled { return }
            state = .error(error.localizedDescription)
        }
    }

    func filterByCuisine(_ cuisine: String) {
        filteredRecipes = allRecipes.filter { $0.cuisine == cuisine }
    }

    func resetFilter() {
        filteredRecipes = allRecipes
    }

    func updateFavorites() {
        favoriteIDs = favoritesService.fetchFavoriteIDs()
    }

    func isFavorite(_ id: UUID) -> Bool {
        favoritesService.isFavorite(id)
    }

    func openInSafari(_ url: URL) {
        selectedURL = url
    }
}

