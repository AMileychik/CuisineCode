//
//  ImageLoaderService.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/8/25.
//

import SwiftUI

protocol ImageLoaderServiceProtocol {
    func loadImage(from url: URL) async throws -> UIImage
}

final class ImageLoaderService: ImageLoaderServiceProtocol {
    
    private let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    func loadImage(from url: URL) async throws -> UIImage {
        let hashedName = String(url.absoluteString.hashValue)
        let fileURL = cacheDirectory.appendingPathComponent(hashedName)
        
        if FileManager.default.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let cachedImage = UIImage(data: data) {
            return cachedImage
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
            try? data.write(to: fileURL)
            return image
        }
        
        throw URLError(.cannotDecodeContentData)
    }
}


@MainActor
final class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var url: URL
    private let imageLoaderService: ImageLoaderServiceProtocol
    
    init(url: URL, service: ImageLoaderServiceProtocol) {
        self.url = url
        self.imageLoaderService = service
    }
    
    func loadImage() {
        Task {
            do {
                let image = try await imageLoaderService.loadImage(from: url)
                self.image = image
            } catch {
                print("Image load failed:", error)
            }
        }
    }
    
    func updateURL(_ newURL: URL) {
        guard newURL != url else { return }
        url = newURL
        image = nil
        loadImage()
    }
}

struct CachedImageView: View {
    @StateObject private var loader: ImageLoader
    private let url: URL
    private let service: ImageLoaderServiceProtocol
    
    init(url: URL, service: ImageLoaderServiceProtocol) {
        self._loader = StateObject(wrappedValue: ImageLoader(url: url, service: service))
        self.url = url
        self.service = service
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image).resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImage()
        }
    }
}


