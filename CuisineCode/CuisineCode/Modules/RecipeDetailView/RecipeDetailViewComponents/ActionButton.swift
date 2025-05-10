//
//  ActionButton.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/7/25.
//

import SwiftUI

struct ActionButton: View {
    
    @Binding var isShowingWebView: Bool
    @Binding var selectedURL: URL?
    
    let safariService: SafariServiceProtocol
    let title: String
    let gradient: [Color]
    let url: URL?

    var body: some View {
        Button {
            if let url = url {
                safariService.open(url: url, in: $isShowingWebView, selectedURL: $selectedURL)
            }
        } label: {
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
