//
//  NetworkService.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/29/25.
//

import Foundation

enum NetworkError: Error {
    case statusCode
    case decodingError(Error)
}

protocol NetworkServiceProtocol {
    func loadRecipes() async throws -> RecipeResponse
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func loadRecipes() async throws -> RecipeResponse {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode
        }
        
        do {
            return try decoder.decode(RecipeResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
