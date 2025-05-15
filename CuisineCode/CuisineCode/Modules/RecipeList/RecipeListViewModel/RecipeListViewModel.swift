//
//  RecipeViewModel.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    
    enum State {
        case initial
        case loading
        case loaded([Recipe])
        case error(String)
    }
    
    @Published var state: State = .initial
    @Published var filteredRecipes: [Recipe] = []
    @Published var searchText = ""
    
    private var allRecipes: [Recipe] = []
    
    private let networkService: NetworkServiceProtocol
    let favoriteService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let safariService: SafariServiceProtocol
    
    var isLoaded: Bool {
        if case .loaded = state {
            return true
        }
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
    
    let bannerURL = URL(string: "https://www.fetch.com")
    
    init(networkService: NetworkServiceProtocol, favoriteService: FavoritesServiceProtocol, imageLoaderService: ImageLoaderServiceProtocol, safariService: SafariServiceProtocol) {
        self.networkService = networkService
        self.favoriteService = favoriteService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
    }
    
    func loadRecipes() async {
        self.state = .loading
        
        do {
            let recipes = try await networkService.loadRecipes()
            self.allRecipes = recipes.recipes
            self.filteredRecipes = recipes.recipes
            self.state = .loaded(recipes.recipes)
        }
        catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    func filterByCuisine(_ cuisine: String) {
        self.filteredRecipes = allRecipes.filter { $0.cuisine == cuisine }
    }
    
    func resetFilter() {
        self.filteredRecipes = allRecipes
    }
}
