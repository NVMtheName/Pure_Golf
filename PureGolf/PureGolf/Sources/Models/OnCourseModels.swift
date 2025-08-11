import Foundation

enum OnCourseCategory: String, CaseIterable, Identifiable {
    case drinks = "Drinks"
    case snacks = "Snacks"
    case specials = "Specials"

    var id: String { rawValue }
}

struct OnCourseItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: OnCourseCategory
    let price: Double
    let description: String
    let icon: String     // SF Symbol name
    let isAlcohol: Bool
}

struct OnCourseLineItem: Identifiable {
    let id = UUID()
    let item: OnCourseItem
    var quantity: Int
}

struct OnCourseOrder: Identifiable {
    let id = UUID()
    let createdAt: Date
    let hole: Int
    let notes: String
    let latitude: Double?
    let longitude: Double?
    let items: [OnCourseLineItem]
    let subtotal: Double
    let tax: Double
    let tip: Double
    let total: Double
}

enum OnCourseOrderStatus: String {
    case preparing = "Preparing"
    case enRoute = "On the way"
    case delivered = "Delivered"
}
