//
//  RecipeDetailViewModel.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/7/25.
//

import SwiftUI

final class RecipeDetailViewModel: ObservableObject {
    
    @Published var isFavorite: Bool = false
    @Published var isDataLoaded: Bool = false
    @Published var image: UIImage?
    
    private let recipe: Recipe
    private let favoritesService: FavoritesServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    let safariService: SafariServiceProtocol
    
    var name: String { recipe.name }
    var cuisine: String { recipe.cuisine }
    var photoURLLarge: URL? { recipe.photoURLLarge }
    var sourceURL: URL? { recipe.sourceURL }
    var youtubeURL: URL? { recipe.youtubeURL }
    
    let partners = Partner.partners
    
    init(recipe: Recipe, favoritesService: FavoritesServiceProtocol, imageLoaderService: ImageLoaderServiceProtocol, safariService: SafariServiceProtocol) {
        self.recipe = recipe
        self.favoritesService = favoritesService
        self.imageLoaderService = imageLoaderService
        self.safariService = safariService
        self.isFavorite = favoritesService.isFavorite(recipe.id)
    }
    
    func toggleFavorite() {
        favoritesService.toggleFavorite(recipe.id)
        isFavorite = favoritesService.isFavorite(recipe.id)
    }
    
    func loadData() async {
        do {
            if let url = recipe.photoURLLarge {
                let loadedImage = try await imageLoaderService.loadImage(from: url)
                await MainActor.run {
                    self.image = loadedImage
                }
            }
            await MainActor.run {
                self.isDataLoaded = true
            }
        } catch {
            print(Texts.RecipeDetailView.imageLoadFailed, error)
            await MainActor.run {
                self.isDataLoaded = true
            }
        }
    }
}


