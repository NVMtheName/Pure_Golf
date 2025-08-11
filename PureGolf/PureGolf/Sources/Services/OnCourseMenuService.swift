import Foundation

enum OnCourseMenuService {
    static let menu: [OnCourseItem] = [
        .init(name: "Bottled Water", category: .drinks, price: 3.00, description: "Cold spring water (16oz).", icon: "drop.fill", isAlcohol: false),
        .init(name: "Sports Drink", category: .drinks, price: 4.50, description: "Electrolyte fuel (20oz).", icon: "bolt.heart.fill", isAlcohol: false),
        .init(name: "Iced Tea", category: .drinks, price: 4.00, description: "Unsweet / Sweet.", icon: "cup.and.saucer.fill", isAlcohol: false),
        .init(name: "Lager", category: .drinks, price: 7.00, description: "Domestic can (21+).", icon: "beer.mug.fill", isAlcohol: true),
        .init(name: "Seltzer", category: .drinks, price: 7.50, description: "Hard seltzer (21+).", icon: "sparkles", isAlcohol: true),

        .init(name: "Protein Bar", category: .snacks, price: 3.50, description: "Chocolate or PB.", icon: "rectangle.fill.on.rectangle.fill", isAlcohol: false),
        .init(name: "Chips", category: .snacks, price: 3.00, description: "Sea salt / BBQ.", icon: "bag.fill", isAlcohol: false),
        .init(name: "Hot Dog", category: .snacks, price: 6.50, description: "Ballpark classic.", icon: "fork.knife.circle.fill", isAlcohol: false),

        .init(name: "Turkey Wrap", category: .specials, price: 9.50, description: "With greens & aioli.", icon: "leaf.circle.fill", isAlcohol: false),
        .init(name: "Birdie Box", category: .specials, price: 12.00, description: "Half wrap + chips + water.", icon: "gift.fill", isAlcohol: false)
    ]

    static func items(for category: OnCourseCategory) -> [OnCourseItem] {
        menu.filter { $0.category == category }
    }
}
