//
//  CuisineCodeApp.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

@main
struct CuisineCodeApp: App {
    
    private let viewModelFactory: ViewModelFactory
    @StateObject private var viewModel: RecipeListViewModel
    
    init() {
        let factory = ViewModelFactory()
        self.viewModelFactory = factory
        _viewModel = StateObject(wrappedValue: factory.makeRecipeListViewModel())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(recipeListViewModel: viewModel)
        }
    }
}


