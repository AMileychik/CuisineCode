//
//  URL + Id.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 5/9/25.
//

import Foundation

extension URL: Identifiable {
    public var id: String { absoluteString }
}
