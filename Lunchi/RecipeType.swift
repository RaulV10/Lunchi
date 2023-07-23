//
//  RecipeType.swift
//  Lunchi
//
//  Created by Raul Villarreal on 21/07/23.
//

import Foundation

enum RecipeType: String, Codable, CaseIterable {
    case breakfast = "Breakfast",
    lunch = "Lunch",
    dinner = "Dinner",
    dessert = "Dessert"
    
    var type: String {
        switch self {
            case .breakfast:
                return "breakfast"
            case .lunch:
                return "lunch"
            case .dinner:
                return "dinner"
            case .dessert:
                return "dessert"
        }
    }
}
