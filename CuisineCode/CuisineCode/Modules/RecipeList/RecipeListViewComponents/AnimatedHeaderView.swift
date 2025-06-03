//
//  HeaderView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct AnimatedFavoriteHeader: View {
    
    @State private var show = false
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [Color.pink.opacity(0.6), Color.red.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(height: 120)
                .shadow(radius: 5)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(Texts.RecipeListView.favorites)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: Images.heartCircleFill)
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                    .scaleEffect(show ? 1 : 0.5)
                    .opacity(show ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: show)
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .onAppear {
            show = true
        }
        .onDisappear {
            show = false
        }
    }
}
