import Foundation

enum MarketplaceService {
    static let categories: [Category] = [
        .init(name: "Tee Times", systemIcon: "flag.checkered"),
        .init(name: "Lessons", systemIcon: "person.fill.questionmark"),
        .init(name: "Gear", systemIcon: "bag"),
        .init(name: "Travel", systemIcon: "airplane"),
        .init(name: "Stays", systemIcon: "house"),
        .init(name: "Club Shipping", systemIcon: "shippingbox")
    ]

    static let products: [Product] = [
        .init(name: "9‑Hole Twilight (Bellagio Hill)", price: 39, description: "Twilight tee time, cart included.", category: "Tee Times", imageSystemName: "sunset.fill"),
        .init(name: "18‑Hole Weekend (Pebble Plains)", price: 129, description: "Prime time Saturday tee time.", category: "Tee Times", imageSystemName: "clock"),
        .init(name: "Swing Fix – 30 min", price: 45, description: "Quick tune‑up with a local pro.", category: "Lessons", imageSystemName: "figure.golf"),
        .init(name: "Premium Lesson – 60 min", price: 85, description: "Full analysis and drills plan.", category: "Lessons", imageSystemName: "camera.viewfinder"),
        .init(name: "PURE Glove (2‑pack)", price: 24, description: "Soft cabretta, tour fit.", category: "Gear", imageSystemName: "hand.raised.fill"),
        .init(name: "Rangefinder (Mock)", price: 149, description: "Tournament‑legal, slope toggle.", category: "Gear", imageSystemName: "scope"),
        .init(name: "Resort Stay – 2 nights", price: 389, description: "Near the course, breakfast incl.", category: "Stays", imageSystemName: "bed.double.fill"),
        .init(name: "Club Shipping: 1 bag", price: 59, description: "Door‑to‑door within US.", category: "Club Shipping", imageSystemName: "shippingbox.fill")
    ]

    static func products(in category: Category) -> [Product] {
        products.filter { $0.category == category.name }
    }
}
