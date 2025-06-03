//
//  CuisineCodeApp.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import SwiftUI

@main
struct CuisineCodeApp: App {
    
    private let container: DependencyContainerProtocol = DependencyContainer.makeDefault()
    private let viewModelFactory: ViewModelFactory
    private let screenFactory: ScreenFactory
        
    init() {
        self.viewModelFactory = ViewModelFactory(container: container)
        self.screenFactory = ScreenFactory(viewModelFactory: viewModelFactory)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(factory: screenFactory)
                .environment(\.imageLoaderService, container.imageLoaderService)
        }
    }
}

