//
//  RecipeListState.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/16/25.
//

import Foundation

enum RecipeListState {
    case initial
    case loading
    case loaded([Recipe])
    case error(String)
}
