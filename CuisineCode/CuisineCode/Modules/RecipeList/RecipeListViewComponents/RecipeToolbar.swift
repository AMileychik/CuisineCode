//
//  RecipeToolbar.swift
//  CuisineCode
//
//  Created by Александр Милейчик on 5/7/25.
//

import SwiftUI

struct RecipeToolbar: ToolbarContent {
    
    let userName: String
    let cuisines: [String]
    let onFilter: (String) -> Void
    let onReset: () -> Void
    
    var body: some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarLeading) {
            WelcomeTextView(userName: userName)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            FilterCuisineView(
                uniqueCuisines: cuisines,
                onFilter: onFilter,
                onReset: onReset
            )
        }
    }
}
