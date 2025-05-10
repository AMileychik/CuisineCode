//
//  FilterMenuView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct FilterCuisineView: View {
    
    let uniqueCuisines: [String]
    var onFilter: (String) -> Void
    var onReset: () -> Void
    
    var body: some View {
        Menu {
            Button(Texts.RecipeListView.all, action: onReset)
            ForEach(uniqueCuisines, id: \.self) { cuisine in
                Button(cuisine) {
                    onFilter(cuisine)
                }
            }
        } label: {
            Image(systemName: Images.filterCuisineViewButton)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}
