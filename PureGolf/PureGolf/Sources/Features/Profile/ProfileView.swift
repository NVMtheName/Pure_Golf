import SwiftUI

struct ProfileView: View {
    @StateObject private var scorecardService = ScorecardService.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Profile")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Handicap Card
                PGCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Handicap Index").font(.headline).foregroundStyle(PGColors.text)
                        Text(String(format: "%.1f", scorecardService.playerStats.currentHandicap))
                            .font(.largeTitle.bold())
                            .foregroundStyle(PGColors.text)
                    }
                }

                // Round Stats
                PGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Round Statistics").font(.headline).foregroundStyle(PGColors.text)
                        
                        HStack {
                            StatItem(title: "Rounds", value: "\(scorecardService.playerStats.totalRounds)")
                            Spacer()
                            StatItem(title: "Average", value: String(format: "%.1f", scorecardService.playerStats.averageScore))
                            Spacer()
                            StatItem(title: "Best", value: scorecardService.playerStats.bestScore < 200 ? "\(scorecardService.playerStats.bestScore)" : "-")
                        }
                    }
                }
                
                // Performance Stats
                PGCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Performance").font(.headline).foregroundStyle(PGColors.text)
                        
                        HStack {
                            StatItem(title: "Fairways", value: String(format: "%.0f%%", scorecardService.playerStats.fairwaysHit * 100))
                            Spacer()
                            StatItem(title: "GIR", value: String(format: "%.0f%%", scorecardService.playerStats.greensInRegulation * 100))
                        }
                        
                        HStack {
                            StatItem(title: "Birdies", value: "\(scorecardService.playerStats.birdies)")
                            Spacer()
                            StatItem(title: "Eagles", value: "\(scorecardService.playerStats.eagles)")
                            Spacer()
                            StatItem(title: "Aces", value: "\(scorecardService.playerStats.aces)")
                        }
                    }
                }
                
                // Recent Rounds
                if !scorecardService.roundHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Rounds")
                            .font(.headline)
                            .foregroundStyle(PGColors.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ForEach(scorecardService.roundHistory.suffix(5).reversed(), id: \.id) { round in
                            RecentRoundCard(round: round)
                                .padding(.horizontal)
                        }
                    }
                }

                Spacer(minLength: 100)
            }
        }
        .pgBackground()
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(PGColors.text)
            Text(title)
                .font(.caption)
                .foregroundStyle(PGColors.subtext)
        }
    }
}

#Preview { ProfileView() }
