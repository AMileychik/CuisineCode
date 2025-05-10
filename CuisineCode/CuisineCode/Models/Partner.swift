//
//  FetchPartner.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/4/25.
//

import Foundation

struct Partner: Identifiable {
    let id = UUID()
    let imageName: String?
    let url: URL?
}

extension Partner {
    
    static let partners: [Partner] = [
        .init(imageName: "Target", url: URL(string: "https://www.target.com")),
        .init(imageName: "UberEat", url: URL(string: "https://www.ubereats.com")),
        .init(imageName: "Walmart", url: URL(string: "https://www.walmart.com"))
    ]
}
