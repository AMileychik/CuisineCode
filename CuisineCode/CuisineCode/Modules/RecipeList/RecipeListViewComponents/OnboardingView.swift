//
//  NamePromptView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @FocusState var isNameFieldFocused: Bool
    @Binding var tempName: String
    @Binding var showNamePrompt: Bool
    var onSave: (String) -> Void
    
    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture { showNamePrompt = false }
        
        VStack(spacing: 8) {
            VStack {
                Text(Texts.RecipeListView.welcome)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            
            Text(Texts.RecipeListView.userName)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            ZStack(alignment: .trailing) {
                TextField(Texts.RecipeListView.userNameInput, text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isNameFieldFocused)
                    .padding(.horizontal)
                
                if !tempName.isEmpty {
                    Button(action: { tempName = "" }) {
                        Image(systemName: Images.xCircleFill)
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            
            HStack {
                Button(Texts.RecipeListView.cancel) { showNamePrompt = false }
                Spacer()
                Button(Texts.RecipeListView.save) {
                    let trimmed = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        onSave(trimmed)
                    }
                    showNamePrompt = false
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                isNameFieldFocused = true
            }
        }
    }
}

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
