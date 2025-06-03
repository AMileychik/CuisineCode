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
    @Published var selectedURL: URL? = nil

    // MARK: - Dependencies
    private let recipe: Recipe
    private let favoritesService: FavoritesServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol

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
        imageLoaderService: ImageLoaderServiceProtocol)
    {
        self.recipe = recipe
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.isFavorite = favoritesService.isFavorite(recipe.id)
    }
    
    func openInSafari(_ url: URL) {
        selectedURL = url
    }

    // MARK: - Data Loading
    func loadData() async {
        if Task.isCancelled { return }
        if let url = recipe.photoURLLarge {
            do {
                image = try await imageLoaderService.loadImage(from: url)
                if Task.isCancelled { return }
            } catch {
                print(Texts.RecipeDetailView.imageLoadFailed, error)
            }
        }
        if Task.isCancelled { return }
        isDataLoaded = true
    }
    
    // MARK: - Actions
    func toggleFavorite() {
        favoritesService.toggleFavorite(recipe.id)
        isFavorite = favoritesService.isFavorite(recipe.id)
    }
}
