//
//  RecipeResponse.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import Foundation

struct RecipeResponse: Decodable, Hashable {
    let recipes: [Recipe]
}


