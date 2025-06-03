//
//  RecipeDetailView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject private var viewModel: RecipeDetailViewModel
    
    init(viewModel: RecipeDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        recipeListContent
    }
    
    // MARK: - Main Content Layer
    private var recipeListContent: some View {
        RecipeDetailContentView(
            viewModel: viewModel
        )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.selectedURL) { SafariView(url: $0) }
        .task {
            await viewModel.loadData()
        }
    }
}
