//
//  OnboardingTextField.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/17/25.
//

import SwiftUI

struct OnboardingTextField: View {
    
    @Binding var text: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(Texts.RecipeListView.userNameInput, text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .padding(.horizontal)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: Images.xCircleFill)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}
