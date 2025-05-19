//
//  RecipeCardView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct RecipeGrid: View {
    
    let recipe: Recipe
    let imageLoaderService: ImageLoaderServiceProtocol

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let photoURL = recipe.photoURLSmall {
                CachedImageView(url: photoURL, service: imageLoaderService)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 48, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
    }
}



