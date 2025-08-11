import Foundation

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let systemIcon: String
}

struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let category: String
    let imageSystemName: String
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}
//
//  MarketplaceModels.swift
//  PureGolf
//
//  Created by Nick Maya on 8/10/25.
//

