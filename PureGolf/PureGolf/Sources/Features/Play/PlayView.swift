import SwiftUI

struct PlayView: View {
    @State private var holeNumber = 1
    @State private var par = 4
    @State private var handicap = 12
    @State private var score = 0
    @State private var aiSuggestion = "7 Iron • 158 yds • Wind: +4 mph"
    @State private var showingAR = false
    @State private var selectedClub = "7 Iron"

    let clubs = ["Driver","3 Wood","5 Iron","6 Iron","7 Iron","8 Iron","9 Iron","PW","SW","Putter"]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hole \(holeNumber)").font(.title2).bold().foregroundStyle(PGColors.text)
                        Text("Par \(par) • HCP \(handicap)").font(.subheadline).foregroundStyle(PGColors.subtext)
                    }
                    Spacer()
                    Text("Score: \(score)").font(.headline).foregroundStyle(PGColors.text)
                }
                .padding()
                .background(PGColors.background.opacity(0.8))

                Text(aiSuggestion)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(PGColors.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    .padding(.top, 4)

                ZStack {
                    if showingAR {
                        Color.black.overlay(
                            Text("AR View Placeholder\n(Overlays coming soon!)")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                        )
                    } else {
                        Image("sampleHoleMap")
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                VStack {
                                    Spacer()
                                    Text("GPS Map View • Hole Layout")
                                        .padding(6)
                                        .background(Color.black.opacity(0.6))
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding(.bottom, 12)
                                }
                            )
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { showingAR.toggle() }) {
                                Text(showingAR ? "Map View" : "AR Mode")
                                    .font(.caption)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(PGColors.accent)
                                    .foregroundStyle(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding()
                            }
                        }
                    }
                }
                .frame(maxHeight: 350)
                .padding(.top, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(clubs, id: \.self) { club in
                            Button { selectedClub = club } label: {
                                Text(club)
                                    .font(.footnote)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(selectedClub == club ? PGColors.accent : PGColors.card)
                                    .foregroundStyle(selectedClub == club ? .black : PGColors.text)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Last Shot").font(.headline).foregroundStyle(PGColors.text)
                    HStack {
                        StatBox(title: "Carry", value: "154 yds")
                        StatBox(title: "Total", value: "160 yds")
                        StatBox(title: "Deviation", value: "3L")
                    }
                }
                .padding()
                .background(PGColors.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.top, 8)

                // Keep content above the tab bar without leaving a big black gap.
                Spacer(minLength: 16)
            }
        }
        .pgBackground()
        .navigationTitle("Play")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    var body: some View {
        VStack {
            Text(value).font(.headline).foregroundStyle(PGColors.text)
            Text(title).font(.caption).foregroundStyle(PGColors.subtext)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(PGColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview { PlayView() }
