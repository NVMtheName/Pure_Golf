import SwiftUI

enum PGColors {
    // PURE green theme
    static let background = Color(red: 30/255, green: 58/255, blue: 46/255)   // #1E3A2E
    static let card       = Color(red: 38/255, green: 68/255, blue: 55/255)   // slightly lighter
    static let text       = Color.white
    static let subtext    = Color.white.opacity(0.7)
    // Accent: emerald green so bordered/prominent buttons aren’t white boxes
    static let accent     = Color(red: 74/255, green: 222/255, blue: 128/255) // #4ADE80
}

struct PGPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.horizontal)
            .background(PGColors.accent.opacity(configuration.isPressed ? 0.75 : 1.0))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(radius: 8, y: 4)
    }
}

struct PGCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(PGColors.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(PGColors.accent.opacity(0.08)))
    }
}

extension View {
    /// Fills the screen with the PURE background color.
    func pgBackground() -> some View {
        self.background(PGColors.background.ignoresSafeArea())
    }
}
