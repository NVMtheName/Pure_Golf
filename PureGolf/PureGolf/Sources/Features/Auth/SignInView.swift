import SwiftUI

struct SignInView: View {
    @EnvironmentObject var session: AppSession

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo & tagline
            VStack(spacing: 12) {
                Image("PureLogo") // add this in Assets as "PureLogo"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .shadow(radius: 10)
                Text("PURE Golf")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(PGColors.text)
                Text("Built by average golfers — for above‑average rounds.")
                    .font(.subheadline)
                    .foregroundStyle(PGColors.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            PGCard {
                VStack(spacing: 12) {
                    Button {
                        session.mockSignIn()
                    } label: {
                        Label("Continue with Apple (Mock)", systemImage: "apple.logo")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(PGPrimaryButton())

                    Button {
                        session.mockSignIn()
                    } label: {
                        Label("Continue with Google (Mock)", systemImage: "globe")
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.bordered)
                    .tint(PGColors.text)
                }
            }
            .padding(.horizontal)

            Text("By continuing you agree to our Terms & Privacy.")
                .font(.footnote)
                .foregroundStyle(PGColors.subtext)
                .padding(.bottom, 8)

            Spacer(minLength: 12)
        }
        .pgBackground()
    }
}

#Preview {
    SignInView().environmentObject(AppSession())
}
