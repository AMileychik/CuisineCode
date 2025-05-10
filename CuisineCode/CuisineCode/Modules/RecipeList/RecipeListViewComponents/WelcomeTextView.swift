//
//  WelcomeTextView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct WelcomeTextView: View {
    
    let userName: String
    
    var body: some View {
        Text(Date().welcomeText(for: userName))
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.primary)
    }
}
