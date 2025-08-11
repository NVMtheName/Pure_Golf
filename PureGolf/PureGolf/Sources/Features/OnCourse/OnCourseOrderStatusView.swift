import SwiftUI

struct OnCourseOrderStatusView: View {
    @EnvironmentObject var cart: OnCourseCartStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let order = cart.lastSubmittedOrder {
                    PGCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Order #\(order.id.uuidString.prefix(6))").font(.headline)
                            Text("Hole \(order.hole)").foregroundStyle(PGColors.subtext)
                            Text("Total: $\(order.total, specifier: "%.2f")").foregroundStyle(PGColors.text)
                            if let lat = order.latitude, let lon = order.longitude {
                                Text("GPS: \(String(format: "%.5f", lat)), \(String(format: "%.5f", lon))")
                                    .font(.footnote).foregroundStyle(PGColors.subtext)
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        statusRow(icon: "clock", title: "Preparing",
                                  isActive: cart.lastStatus == .preparing || cart.lastStatus == .enRoute || cart.lastStatus == .delivered)
                        statusRow(icon: "car.fill", title: "On the way",
                                  isActive: cart.lastStatus == .enRoute || cart.lastStatus == .delivered)
                        statusRow(icon: "checkmark.seal.fill", title: "Delivered",
                                  isActive: cart.lastStatus == .delivered)
                    }
                    .padding(.horizontal)
                } else {
                    ContentUnavailableView("No recent order", systemImage: "cart",
                                           description: Text("Place an order from the On-Course tab."))
                        .padding()
                }
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle("Order Status")
        .pgBackground()
        .toolbarBackground(PGColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func statusRow(icon: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(isActive ? PGColors.accent : PGColors.subtext)
            Text(title)
                .foregroundStyle(isActive ? PGColors.text : PGColors.subtext)
            Spacer()
            if isActive { ProgressView().tint(PGColors.accent) }
        }
        .padding()
        .background(PGColors.card, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let store = OnCourseCartStore()
    store.lastSubmittedOrder = OnCourseOrder(
        createdAt: .now, hole: 7, notes: "", latitude: 37.3318, longitude: -122.0312,
        items: [], subtotal: 10, tax: 0.75, tip: 1.5, total: 12.25
    )
    store.lastStatus = .enRoute
    return NavigationStack { OnCourseOrderStatusView().environmentObject(store) }
}
