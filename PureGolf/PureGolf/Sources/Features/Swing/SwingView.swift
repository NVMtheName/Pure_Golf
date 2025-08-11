import SwiftUI

struct SwingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Swing")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Analyzer").font(.headline)
                        Text("Record swings and see instant metrics.")
                            .foregroundStyle(PGColors.subtext)
                    }
                }

                Spacer(minLength: 8)
            }
            .padding(.bottom, 8)
        }
        .pgBackground()
    }
}

#Preview { SwingView() }
