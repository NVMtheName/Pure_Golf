import SwiftUI

@MainActor
final class CartStore: ObservableObject {
    @Published var items: [CartItem] = []

    var count: Int { items.reduce(0) { $0 + $1.quantity } }
    var total: Double { items.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) } }

    func add(_ product: Product) {
        if let idx = items.firstIndex(where: { $0.product.id == product.id }) {
            items[idx].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func remove(_ product: Product) {
        guard let idx = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        items[idx].quantity -= 1
        if items[idx].quantity <= 0 { items.remove(at: idx) }
    }

    func clear() { items.removeAll() }
}
