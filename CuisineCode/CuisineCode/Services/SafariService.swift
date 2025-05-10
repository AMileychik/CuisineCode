//
//  SafariService.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/8/25.
//

import SwiftUI
import SafariServices

protocol SafariServiceProtocol {
    func open(url: URL, in binding: Binding<Bool>, selectedURL: Binding<URL?>)
}

final class SafariService: SafariServiceProtocol {
    
    func open(url: URL, in binding: Binding<Bool>, selectedURL: Binding<URL?>) {
        selectedURL.wrappedValue = url
        binding.wrappedValue = true
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}




