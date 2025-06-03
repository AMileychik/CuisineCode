//
//  ActionButton.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/7/25.
//

import SwiftUI

struct ActionButton: View {
    
    let title: String
    let gradient: [Color]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}
