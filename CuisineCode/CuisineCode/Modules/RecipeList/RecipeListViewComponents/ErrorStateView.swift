//
//  ErrorStateView.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/16/25.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Images.exclamationmarkTriangleFill)
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text("Error:")
                .font(.headline)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
