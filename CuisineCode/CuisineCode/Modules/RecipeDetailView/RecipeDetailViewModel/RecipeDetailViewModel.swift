//
//  RecipeDetailViewModel.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/7/25.
//

import SwiftUI

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isFavorite: Bool = false
    @Published var isDataLoaded: Bool = false
    @Published var image: UIImage?

    // MARK: - Dependencies
    private let recipe: Recipe
    private let favoritesService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let safariService: SafariServiceProtocol

    // MARK: - Computed Properties
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    var photoURLLarge: URL? { recipe.photoURLLarge }
    var sourceURL: URL? { recipe.sourceURL }
    var youtubeURL: URL? { recipe.youtubeURL }

    let partners = Partner.partners

    // MARK: - Init
    init(
        recipe: Recipe,
        favoritesService: FavoritesServiceProtocol,
        imageLoaderService: ImageLoaderServiceProtocol,
        safariService: SafariServiceProtocol
    ) {
        self.recipe = recipe
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
        self.isFavorite = favoritesService.isFavorite(recipe.id)
    }

    // MARK: - Data Loading
    func loadData() async {
        if let url = recipe.photoURLLarge {
            do {
                image = try await imageLoaderService.loadImage(from: url)
            } catch {
                print(Texts.RecipeDetailView.imageLoadFailed, error)
            }
        }
        isDataLoaded = true
    }
    
    // MARK: - Actions
    func toggleFavorite() {
        favoritesService.toggleFavorite(recipe.id)
        isFavorite = favoritesService.isFavorite(recipe.id)
    }
}
