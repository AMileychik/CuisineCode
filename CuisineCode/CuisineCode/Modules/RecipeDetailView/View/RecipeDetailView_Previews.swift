//
//  RecipeDetailView_Previews.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/30/25.
//

import SwiftUI

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let container = DependencyContainer.preview
        
        let viewModel = RecipeDetailViewModel(
            recipe: .mock,
            favoritesService: MockFavoritesService(),
            imageLoaderService: container.imageLoaderService, 
            safariService: container.safariService
        )
        
        viewModel.isDataLoaded = true
        
        return RecipeDetailView(viewModel: viewModel)
            .environment(\.dependencyContainer, container)
    }
}

final class MockFavoritesService: FavoritesServiceProtocol {
    
    var favoriteIDs: Set<String> = []
    
    init(favoriteIDs: Set<String> = []) {
        self.favoriteIDs = favoriteIDs
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favoriteIDs.contains(id.uuidString)
    }
    
    func toggleFavorite(_ id: UUID) {
        let idString = id.uuidString
        if favoriteIDs.contains(idString) {
            favoriteIDs.remove(idString)
        } else {
            favoriteIDs.insert(idString)
        }
    }
}

final class MockImageLoaderService: ImageLoaderServiceProtocol {
    
    func loadImage(from url: URL) async throws -> UIImage {
        guard let image = UIImage(named: "logo") else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}

final class MockSafariService: SafariServiceProtocol {
    func open(url: URL, in isPresented: Binding<Bool>, selectedURL: Binding<URL?>) {
        selectedURL.wrappedValue = url
        isPresented.wrappedValue = true
    }
}

extension DependencyContainer {
    static var preview: DependencyContainer {
        DependencyContainer(
            imageLoaderService: MockImageLoaderService(),
            safariService: MockSafariService()
        )
    }
}
