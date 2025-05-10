//
//  HeaderView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/3/25.
//

import SwiftUI

struct HeaderView: View {
    let text: String

    var body: some View {
        Spacer()
        HStack {
            Text(text)
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 20)
    }
}




