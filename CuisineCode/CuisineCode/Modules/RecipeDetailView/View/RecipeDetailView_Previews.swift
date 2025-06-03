//
//  RecipeDetailView_Previews.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/30/25.
//

import SwiftUI

struct RecipeDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let mockNetworkService = PreviewMockNetworkService()
        let mockFavoritesService = PreviewMockFavoritesService(networkService: mockNetworkService)
        
        let viewModel = RecipeDetailViewModel(
            recipe: .mock,
            favoritesService: mockFavoritesService,
            imageLoaderService: PreviewMockImageLoaderService()
        )
        
        viewModel.isDataLoaded = true
        
        return RecipeDetailView(viewModel: viewModel)
    }
}
