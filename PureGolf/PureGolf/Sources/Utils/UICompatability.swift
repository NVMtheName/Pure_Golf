import SwiftUI

// MARK: - Safe, SDK-friendly List containers

/// Plain list that works across SDKs and avoids bottom "gap" above the tab bar.
struct PGPlainList<Content: View>: View {
    let bottomInset: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            List { content() }
                .listStyle(PlainListStyle())
                .modifier(PGListCompat())

            // Small spacer so content doesn't feel jammed against the tab bar
            Color.clear.frame(height: bottomInset)
        }
    }
}

/// Inset-grouped list that works across SDKs and avoids bottom "gap".
struct PGInsetGroupedList<Content: View>: View {
    let bottomInset: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            List { content() }
                .listStyle(InsetGroupedListStyle())
                .modifier(PGListCompat())

            Color.clear.frame(height: bottomInset)
        }
    }
}

/// Applies newer list tweaks only when available (older SDKs compile cleanly).
private struct PGListCompat: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 16.0, *) {
                content
                    .scrollContentBackground(.hidden)     // remove list's default bg
                    .listSectionSpacing(.default)         // harmless normalization
            } else {
                content
            }
        }
    }
}

// MARK: - Toolbar helpers

extension View {
    /// Makes the tab bar background visible/opaque when the API exists (no-ops otherwise).
    @ViewBuilder
    func pgToolbarTabBarBackground(_ color: Color) -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarBackground(color, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        } else {
            self
        }
    }
}
