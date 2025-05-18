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
        .init(imageName: "Target", url: URLs.target),
        .init(imageName: "UberEat", url: URLs.uberEat),
        .init(imageName: "Walmart", url: URLs.walmart)
    ]
}
