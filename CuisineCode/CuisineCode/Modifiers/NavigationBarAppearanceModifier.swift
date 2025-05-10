//
//  NavigationBarAppearanceModifier.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

struct WhiteNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white
                appearance.shadowColor = .clear
                
                let navigationBar = UINavigationBar.appearance()
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = appearance
                navigationBar.compactAppearance = appearance
            }
    }
}

extension View {
    func whiteNavigationBar() -> some View {
        self.modifier(WhiteNavigationBarModifier())
    }
}
