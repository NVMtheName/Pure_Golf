
import SwiftUI

struct ScorecardView: View {
    @StateObject private var scorecardService = ScorecardService.shared
    @State private var selectedHole = 1
    @State private var showingHoleDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let round = scorecardService.currentRound {
                    // Course Info Header
                    VStack(spacing: 8) {
                        Text(round.courseName)
                            .font(.title2.bold())
                            .foregroundStyle(PGColors.text)
                        
                        HStack {
                            Text("Total: \(round.totalScore)")
                            Spacer()
                            Text("Par: \(round.totalPar)")
                            Spacer()
                            Text("Score: \(round.scoreToPar >= 0 ? "+" : "")\(round.scoreToPar)")
                                .foregroundStyle(round.scoreToPar <= 0 ? .green : .red)
                        }
                        .font(.headline)
                        .foregroundStyle(PGColors.text)
                    }
                    .padding()
                    .background(PGColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    // Holes Grid
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                            ForEach(round.holes) { hole in
                                HoleCard(hole: hole) {
                                    selectedHole = hole.holeNumber
                                    showingHoleDetail = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Complete Round Button
                        if round.isCompleted {
                            Button("Complete Round") {
                                scorecardService.completeRound()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding()
                        }
                        
                        Spacer(minLength: 100)
                    }
                } else {
                    // No Active Round
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 64))
                            .foregroundStyle(PGColors.accent)
                        
                        Text("No Active Round")
                            .font(.title2.bold())
                            .foregroundStyle(PGColors.text)
                        
                        Text("Start a new round from the Courses tab")
                            .foregroundStyle(PGColors.subtext)
                        
                        // Recent Rounds
                        if !scorecardService.roundHistory.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Rounds")
                                    .font(.headline)
                                    .foregroundStyle(PGColors.text)
                                
                                ForEach(scorecardService.roundHistory.suffix(3).reversed(), id: \.id) { round in
                                    RecentRoundCard(round: round)
                                }
                            }
                            .padding(.top, 24)
                        }
                    }
                    .padding()
                }
            }
            .pgBackground()
            .navigationTitle("Scorecard")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingHoleDetail) {
            if let round = scorecardService.currentRound {
                HoleDetailView(
                    hole: round.holes.first { $0.holeNumber == selectedHole }!,
                    onUpdate: { updatedHole in
                        scorecardService.updateHoleScore(selectedHole, strokes: updatedHole.strokes)
                        scorecardService.updateHoleStats(
                            selectedHole,
                            putts: updatedHole.putts,
                            fairwayHit: updatedHole.fairwayHit,
                            gir: updatedHole.greenInRegulation,
                            notes: updatedHole.notes
                        )
                    }
                )
            }
        }
    }
}

struct HoleCard: View {
    let hole: HoleScore
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(hole.holeNumber)")
                    .font(.headline.bold())
                    .foregroundStyle(PGColors.text)
                
                Text("Par \(hole.par)")
                    .font(.caption)
                    .foregroundStyle(PGColors.subtext)
                
                Text(hole.strokes > 0 ? "\(hole.strokes)" : "-")
                    .font(.title2.bold())
                    .foregroundStyle(hole.strokes > 0 ? (hole.scoreToPar <= 0 ? .green : .red) : PGColors.subtext)
                
                if hole.strokes > 0 {
                    Text(hole.scoreText)
                        .font(.caption2)
                        .foregroundStyle(PGColors.subtext)
                }
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(PGColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct RecentRoundCard: View {
    let round: Round
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(round.courseName)
                    .font(.subheadline.bold())
                    .foregroundStyle(PGColors.text)
                
                Text(round.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(PGColors.subtext)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(round.totalScore)")
                    .font(.headline.bold())
                    .foregroundStyle(PGColors.text)
                
                Text("\(round.scoreToPar >= 0 ? "+" : "")\(round.scoreToPar)")
                    .font(.caption)
                    .foregroundStyle(round.scoreToPar <= 0 ? .green : .red)
            }
        }
        .padding()
        .background(PGColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ScorecardView()
}
