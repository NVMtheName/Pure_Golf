import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Profile")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Handicap Index").font(.headline)
                        Text("12.4").font(.largeTitle.bold())
                    }
                }

                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rounds").font(.headline)
                        Text("Last 20: Avg 84.3").foregroundStyle(PGColors.subtext)
                    }
                }

                Spacer(minLength: 16)
            }
            .padding(.horizontal)
        }
        .pgBackground()
    }
}

#Preview { ProfileView() }
