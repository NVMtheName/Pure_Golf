import SwiftUI
import CoreLocation

@MainActor
final class OnCourseCartStore: ObservableObject {
    @Published var items: [OnCourseLineItem] = []
    @Published var tipPercent: Int = 15
    @Published var lastSubmittedOrder: OnCourseOrder?
    @Published var lastStatus: OnCourseOrderStatus? = nil

    var count: Int { items.reduce(0) { $0 + $1.quantity } }
    var subtotal: Double { items.reduce(0) { $0 + (Double($1.quantity) * $1.item.price) } }
    var tax: Double { subtotal * 0.075 }
    var tip: Double { subtotal * Double(tipPercent) / 100.0 }
    var total: Double { subtotal + tax + tip }

    func add(_ item: OnCourseItem, quantity: Int = 1) {
        if let idx = items.firstIndex(where: { $0.item.id == item.id }) {
            items[idx].quantity += quantity
        } else {
            items.append(OnCourseLineItem(item: item, quantity: quantity))
        }
    }

    func remove(_ item: OnCourseItem) {
        guard let idx = items.firstIndex(where: { $0.item.id == item.id }) else { return }
        items[idx].quantity -= 1
        if items[idx].quantity <= 0 { items.remove(at: idx) }
    }

    func clear() { items.removeAll() }

    func submit(hole: Int, notes: String, location: CLLocation?) async {
        let order = OnCourseOrder(
            createdAt: Date(),
            hole: hole,
            notes: notes,
            latitude: location?.coordinate.latitude,
            longitude: location?.coordinate.longitude,
            items: items,
            subtotal: subtotal,
            tax: tax,
            tip: tip,
            total: total
        )
        self.lastSubmittedOrder = order
        self.lastStatus = .preparing

        // Simulate status updates over time
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2s
        self.lastStatus = .enRoute
        try? await Task.sleep(nanoseconds: 4_000_000_000) // 4s
        self.lastStatus = .delivered

        // keep cart after submit? for demo we clear
        clear()
    }
}
