//
//  Date+WelcomeText.swift
//  CuisineCode
//
//  Created by Alexander Mileychik on 4/30/25.
//

import Foundation

extension Date {
    func welcomeText(for name: String) -> String {
        let hour = Calendar.current.component(.hour, from: self)
        let greeting: String

        switch hour {
        case 5...11:
            greeting = "Good Morning"
        case 12...17:
            greeting = "Good Afternoon"
        case 18...23:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }

        return "\(greeting), \(name)"
    }
}
