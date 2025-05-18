//
//  RecipeDetailView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    // MARK: - State
    @StateObject var viewModel: RecipeDetailViewModel
    @State private var isShowingWebView: Bool = false
    @State private var selectedURL: URL?
    
    // MARK: - Init
    init(viewModel: RecipeDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        recipeDetailContent
    }
    
    private var recipeDetailContent: some View {
        RecipeDetailContentView(
            viewModel: viewModel,
            isShowingWebView: $isShowingWebView,
            selectedURL: $selectedURL
        )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedURL) { SafariView(url: $0) }
        .task { await viewModel.loadData() }
    }
}



