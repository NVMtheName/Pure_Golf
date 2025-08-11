import SwiftUI

struct SocialView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Social")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                ForEach(0..<5) { i in
                    PGCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Friend \(i+1) posted a new score").font(.headline)
                            Text("76 at Pacific Dunes").foregroundStyle(PGColors.subtext)
                        }
                    }
                }

                Spacer(minLength: 16)
            }
            .padding(.horizontal)
        }
        .pgBackground()
    }
}

#Preview { SocialView() }
