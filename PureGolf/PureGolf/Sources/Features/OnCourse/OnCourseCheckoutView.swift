import SwiftUI
import CoreLocation

struct OnCourseCheckoutView: View {
    @EnvironmentObject var cart: OnCourseCartStore
    @StateObject private var loc = LocationService.shared

    @State private var selectedHole: Int = 1
    @State private var notes: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if loc.authorization == .notDetermined {
                    Button("Allow Location Access") { loc.requestWhenInUse() }
                        .buttonStyle(PGPrimaryButton())
                }

                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Deliver To").font(.headline)
                        Picker("Hole", selection: $selectedHole) {
                            ForEach(1...18, id: \.self) { Text("Hole \($0)").tag($0) }
                        }
                        .pickerStyle(.menu)

                        if let l = loc.lastLocation {
                            Text("Your GPS: \(String(format: "%.5f", l.coordinate.latitude)), \(String(format: "%.5f", l.coordinate.longitude))")
                                .font(.footnote).foregroundStyle(PGColors.subtext)
                        } else {
                            Text("Waiting for GPS fix…").font(.footnote).foregroundStyle(PGColors.subtext)
                        }

                        Button("Use My Current Location") { loc.requestOneShotLocation() }
                            .buttonStyle(.bordered)
                            .tint(PGColors.accent)
                    }
                }

                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Order Notes").font(.headline)
                        TextField("e.g., “We’re in a green cart, white hats.”", text: $notes, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }

                HStack { Text("Total").bold(); Spacer(); Text("$\(cart.total, specifier: "%.2f")").bold() }
                    .foregroundStyle(PGColors.text)
                    .padding(.horizontal)

                NavigationLink {
                    OnCourseOrderStatusView()
                        .task { await cart.submit(hole: selectedHole, notes: notes, location: loc.lastLocation) }
                } label: { Text("Place Order") }
                .buttonStyle(PGPrimaryButton())
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle("Checkout")
        .pgBackground()
        .toolbarBackground(PGColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            if loc.authorization == .notDetermined { loc.requestWhenInUse() }
            else { loc.requestOneShotLocation() }
        }
    }
}

#Preview {
    let store = OnCourseCartStore()
    store.add(OnCourseMenuService.menu.first!, quantity: 2)
    return NavigationStack { OnCourseCheckoutView().environmentObject(store) }
}
