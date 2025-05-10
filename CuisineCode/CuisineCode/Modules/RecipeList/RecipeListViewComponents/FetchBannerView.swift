//
//  RecipeBannerView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct FetchBannerView: View {
    var onTap: () -> Void

    var body: some View {
        ZStack {
            Color(red: 32/255, green: 4/255, blue: 39/255)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .padding(.top, 6)

                    Text(Texts.RecipeListView.bunnelLogo)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(Texts.RecipeListView.bunnelLogo2)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                Spacer()
                Image("Banner")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 275)
            }
        }
        .frame(height: 275)
        .onTapGesture {
            onTap()
        }
    }
}
