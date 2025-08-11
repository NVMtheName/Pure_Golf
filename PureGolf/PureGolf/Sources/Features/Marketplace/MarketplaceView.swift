import SwiftUI

struct MarketplaceView: View {
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let price: Double
        let icon: String
    }

    private let items: [Item] = [
        .init(name: "PURE Rope Hat",     price: 34, icon: "baseball.diamond.bases"),
        .init(name: "Blade Putter Cover", price: 49, icon: "flag.2.crossed"),
        .init(name: "Tour Towel",         price: 22, icon: "square.grid.3x3.fill")
    ]

    var body: some View {
        NavigationStack {
            // We build a tiny spacer under the List to control bottom padding,
            // which works on all iOS versions.
            VStack(spacing: 0) {
                List {
                    ForEach(items) { p in
                        NavigationLink {
                            ProductDetailView(name: p.name, price: p.price, icon: p.icon)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: p.icon)
                                    .font(.title3)
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(.black)
                                    .background(PGColors.accent, in: RoundedRectangle(cornerRadius: 8))
                                Text(p.name).foregroundStyle(PGColors.text)
                                Spacer()
                                Text("$\(p.price, specifier: "%.0f")").foregroundStyle(PGColors.text)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(PGColors.card)
                    }
                }
                .listStyle(PlainListStyle())

                // Small bottom inset so content doesn’t look cramped above the tab bar.
                Color.clear.frame(height: 8)
            }
            .navigationTitle("Market")
        }
        .pgBackground()
    }
}

#Preview { MarketplaceView() }
