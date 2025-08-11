import SwiftUI

struct OnCourseCartView: View {
    @EnvironmentObject var cart: OnCourseCartStore

    var body: some View {
        VStack(spacing: 12) {
            if cart.items.isEmpty {
                ContentUnavailableView("Your cart is empty", systemImage: "cart",
                                       description: Text("Add items from the On-Course menu."))
                    .padding()
            } else {
                List {
                    ForEach(cart.items) { line in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(line.item.name).foregroundStyle(PGColors.text)
                                Text("$\(line.item.price, specifier: "%.2f") each")
                                    .font(.caption).foregroundStyle(PGColors.subtext)
                            }
                            Spacer()
                            Stepper(value: Binding(
                                get: { line.quantity },
                                set: { newVal in
                                    let delta = newVal - line.quantity
                                    if delta > 0 { cart.add(line.item, quantity: delta) }
                                    else { for _ in 0..<abs(delta) { cart.remove(line.item) } }
                                }
                            ), in: 0...20) { Text("\(line.quantity)") }
                            .labelsHidden()
                            .tint(PGColors.accent)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .ignoresSafeArea(.container, edges: .bottom)

                VStack(spacing: 6) {
                    HStack { Text("Subtotal"); Spacer(); Text("$\(cart.subtotal, specifier: "%.2f")") }
                    HStack { Text("Tax");      Spacer(); Text("$\(cart.tax, specifier: "%.2f")") }
                    HStack {
                        Text("Tip"); Spacer()
                        Picker("", selection: $cart.tipPercent) {
                            ForEach([0,10,15,18,20,25], id: \.self) { p in Text("\(p)%").tag(p) }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                    HStack { Text("Total").bold(); Spacer(); Text("$\(cart.total, specifier: "%.2f")").bold() }
                }
                .foregroundStyle(PGColors.text)
                .padding()
                .background(PGColors.card, in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                NavigationLink(destination: OnCourseCheckoutView()) {
                    Text("Proceed to Checkout")
                }
                .buttonStyle(PGPrimaryButton())
                .padding(.horizontal)
            }
        }
        .navigationTitle("Cart")
        .pgBackground()
        .toolbarBackground(PGColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    let store = OnCourseCartStore()
    store.add(OnCourseMenuService.menu[0], quantity: 2)
    return NavigationStack { OnCourseCartView().environmentObject(store) }
}
