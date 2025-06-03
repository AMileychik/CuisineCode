//
//  RecipeImageView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/4/25.
//

import SwiftUI

struct RecipeImageView: View {
    
    let url: URL?
    
    var body: some View {
        if let url = url {
            CachedImageView(url: url)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 450)
                .clipped()
        } else {
            ProgressView()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
        }
    }
}

