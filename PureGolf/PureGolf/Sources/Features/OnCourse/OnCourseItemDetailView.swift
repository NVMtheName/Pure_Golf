import SwiftUI

struct OnCourseItemDetailView: View {
    @EnvironmentObject var cart: OnCourseCartStore
    let item: OnCourseItem
    @State private var qty = 1

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: item.icon)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .frame(width: 64, height: 64)
                        .background(PGColors.accent, in: RoundedRectangle(cornerRadius: 16))
                    VStack(alignment: .leading) {
                        Text(item.name).font(.title2).bold().foregroundStyle(PGColors.text)
                        Text(item.description).foregroundStyle(PGColors.subtext)
                    }
                    Spacer()
                    Text("$\(item.price, specifier: "%.2f")").font(.title3).foregroundStyle(PGColors.text)
                }

                Stepper("Quantity: \(qty)", value: $qty, in: 1...12).tint(PGColors.accent)
                Button("Add to Cart") { cart.add(item, quantity: qty) }.buttonStyle(PGPrimaryButton())
                if item.isAlcohol {
                    Text("Alcoholic beverages require valid ID at delivery.").font(.footnote).foregroundStyle(.yellow)
                }
                Spacer(minLength: 0)
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .pgBackground()
        .navigationTitle(item.name)
        .toolbarBackground(PGColors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    OnCourseItemDetailView(item: OnCourseMenuService.menu.first!)
        .environmentObject(OnCourseCartStore())
}
