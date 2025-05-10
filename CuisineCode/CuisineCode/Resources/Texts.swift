//
//  Texts.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import Foundation

enum Texts {
    enum RecipeListView {
        static let progressViewState = "Loading recipes..."
        static let recipeHeader = "Inspiring recipes worldwide"
        static let favoriteRecipesHeader = "Your Favorite Recipes"
        static let emptyFavoritesList = "There are no recipes available."
        static let searchRecipes = "Search recipes"
        static let welcome = "Hello!"
        static let userName = "May I know your name?"
        static let userNameInput = "Enter your name"
        static let cancel = "Cancel"
        static let save = "Save"
        static let all = "All"
        static let bunnelLogo = "America's Rewards App"
        static let bunnelLogo2 = "Shop, snap and play to earn free gift cards with Fetch!"
        static let favorites = "Favorites"
    }
    
    enum RecipeDetailView {
        static let addToFavorites = "Add to Favorites"
        static let removeFromFavorites = "Remove from Favorites"
        static let viewRecipe = "View Recipe" 
        static let watchOnYouTube = "Watch on YouTube"
        static let imageLoadFailed = "Image load failed:"
        static let headerText = "Earn"
        static let headerText2 = "Fetch Points"
        static let headerText3 = "Buy ingredients from our partners"
    }
}
