import SwiftUI

struct OnCourseHomeView: View {
    @EnvironmentObject var cart: OnCourseCartStore
    @State private var selected: OnCourseCategory = .drinks
    @State private var query: String = ""

    private var filtered: [OnCourseItem] {
        let base = OnCourseMenuService.items(for: selected)
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? base : base.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    // Search
                    Section {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass").foregroundStyle(PGColors.subtext)
                            TextField("Search menu…", text: $query)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(PGColors.card, in: RoundedRectangle(cornerRadius: 12))
                    }

                    // Segmented control
                    Section {
                        Picker("", selection: $selected) {
                            ForEach(OnCourseCategory.allCases) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Items
                    Section {
                        ForEach(filtered) { item in
                            NavigationLink {
                                OnCourseItemDetailView(item: item)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: item.icon)
                                        .font(.title3)
                                        .frame(width: 36, height: 36)
                                        .foregroundStyle(.black)
                                        .background(PGColors.accent, in: RoundedRectangle(cornerRadius: 8))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name).font(.headline).foregroundStyle(PGColors.text)
                                        Text(item.description).font(.caption).foregroundStyle(PGColors.subtext)
                                    }
                                    Spacer()
                                    Text("$\(item.price, specifier: "%.2f")").foregroundStyle(PGColors.text)
                                    Image(systemName: "chevron.right").font(.footnote).foregroundStyle(PGColors.subtext)
                                }
                                .padding(.vertical, 2)
                            }
                            .listRowBackground(PGColors.card)
                        }
                    }

                    // Cart summary
                    Section {
                        NavigationLink {
                            OnCourseCartView()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "cart.fill")
                                Text(cart.count == 0 ? "Cart is empty"
                                     : "\(cart.count) item\(cart.count == 1 ? "" : "s") • $\(cart.subtotal, specifier: "%.2f")")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(PGColors.text)
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(PGColors.card)
                    }
                }
                .listStyle(InsetGroupedListStyle())

                Color.clear.frame(height: 8)
            }
            .navigationTitle("On-Course")
        }
        .pgBackground()
    }
}

#Preview { OnCourseHomeView().environmentObject(OnCourseCartStore()) }
