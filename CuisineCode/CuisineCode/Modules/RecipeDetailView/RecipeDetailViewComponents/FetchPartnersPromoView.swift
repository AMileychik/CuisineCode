//
//  FetchPartnersPromoView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/4/25.
//

import SwiftUI

struct FetchPartnersPromoView: View {
    
    @Environment(\.openURL) private var openURL
    @State private var isShowingWebView: Bool = false
    @State private var selectedURL: URL?
    
    let partners: [Partner]
    let safariService: SafariServiceProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(Texts.RecipeDetailView.headerText)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(Texts.RecipeDetailView.headerText2)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            Text(Texts.RecipeDetailView.headerText3)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(partners) { partner in
                        Button {
                            if let url = partner.url {
                                safariService.open(url: url, in: $isShowingWebView, selectedURL: $selectedURL)
                            }
                        } label: {
                            if let imageName = partner.imageName {
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 150, height: 176)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 6)
            }
        }
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $isShowingWebView) {
            if let url = selectedURL {
                SafariView(url: url)
            }
        }
    }
}
