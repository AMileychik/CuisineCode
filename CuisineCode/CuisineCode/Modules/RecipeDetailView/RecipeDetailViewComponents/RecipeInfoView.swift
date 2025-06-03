//
//  RecipeInfoView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/4/25.
//

import SwiftUI

struct RecipeInfoView: View {
  
    let name: String
    let cuisine: String
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Cuisine: \(cuisine)")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Button(action: toggleFavorite) {
                Label(
                    isFavorite ? Texts.RecipeDetailView.removeFromFavorites : Texts.RecipeDetailView.addToFavorites,
                    systemImage: isFavorite ? Images.filledHeart : Images.heart
                )
                .foregroundColor(.red)
                .font(.headline)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
    }
}
