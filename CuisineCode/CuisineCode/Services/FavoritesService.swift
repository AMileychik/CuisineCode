//
//  FavoritesService.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/2/25.
//

import SwiftUI

protocol FavoritesServiceProtocol {
    var favoriteIDs: Set<String> { get }
    func isFavorite(_ id: UUID) -> Bool
    func toggleFavorite(_ id: UUID)
}

final class FavoritesService: ObservableObject, FavoritesServiceProtocol {
    
    @AppStorage("favoriteRecipeIDs") private var favoriteIDsData: Data = Data()
    @Published private(set) var favoriteIDs: Set<String> = []
    
    init() {
        load()
    }
    
    private func load() {
        if let ids = try? JSONDecoder().decode(Set<String>.self, from: favoriteIDsData) {
            favoriteIDs = ids
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(favoriteIDs) {
            favoriteIDsData = data
        }
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favoriteIDs.contains(id.uuidString)
    }
    
    func toggleFavorite(_ id: UUID) {
        let idString = id.uuidString
        if favoriteIDs.contains(idString) {
            favoriteIDs.remove(idString)
        } else {
            favoriteIDs.insert(idString)
        }
        save()
    }
}


