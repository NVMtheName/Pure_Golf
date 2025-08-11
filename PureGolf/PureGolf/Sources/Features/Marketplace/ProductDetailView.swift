import SwiftUI

struct ProductDetailView: View {
    let name: String
    let price: Double
    let icon: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .frame(width: 64, height: 64)
                        .background(PGColors.accent, in: RoundedRectangle(cornerRadius: 16))
                    VStack(alignment: .leading) {
                        Text(name).font(.title2).bold().foregroundStyle(PGColors.text)
                        Text("$\(price, specifier: "%.0f")").foregroundStyle(PGColors.text)
                    }
                    Spacer()
                }

                Text("Clean design, premium materials, built for golfers. This is a placeholder description you can swap for real product data.")
                    .foregroundStyle(PGColors.subtext)

                Button("Add to Cart") { }.buttonStyle(PGPrimaryButton())
                Spacer(minLength: 0)
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .bottom) // extend to tab bar
        .pgBackground()
        .navigationTitle(name)
        .toolbarBackground(PGColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview { ProductDetailView(name: "PURE Rope Hat", price: 34, icon: "baseball.diamond.bases") }
