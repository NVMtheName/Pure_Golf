
import Foundation

@MainActor
class ScorecardService: ObservableObject {
    static let shared = ScorecardService()
    
    @Published var currentRound: Round?
    @Published var playerStats = PlayerStats()
    @Published var roundHistory: [Round] = []
    
    private init() {
        loadData()
    }
    
    func startNewRound(course: Course) {
        let holes = (1...18).map { holeNumber in
            HoleScore(
                holeNumber: holeNumber,
                par: [3, 4, 5, 4, 3, 4, 4, 5, 4, 4, 3, 5, 4, 3, 4, 4, 5, 4][holeNumber - 1], // Sample pars
                handicap: holeNumber
            )
        }
        
        currentRound = Round(
            courseId: course.id,
            courseName: course.name,
            date: Date(),
            holes: holes
        )
    }
    
    func updateHoleScore(_ holeNumber: Int, strokes: Int) {
        guard let roundIndex = currentRound?.holes.firstIndex(where: { $0.holeNumber == holeNumber }) else { return }
        currentRound?.holes[roundIndex].strokes = strokes
    }
    
    func addShot(to holeNumber: Int, shot: Shot) {
        guard let roundIndex = currentRound?.holes.firstIndex(where: { $0.holeNumber == holeNumber }) else { return }
        currentRound?.holes[roundIndex].shots.append(shot)
    }
    
    func updateHoleStats(_ holeNumber: Int, putts: Int, fairwayHit: Bool?, gir: Bool?, notes: String) {
        guard let roundIndex = currentRound?.holes.firstIndex(where: { $0.holeNumber == holeNumber }) else { return }
        currentRound?.holes[roundIndex].putts = putts
        currentRound?.holes[roundIndex].fairwayHit = fairwayHit
        currentRound?.holes[roundIndex].greenInRegulation = gir
        currentRound?.holes[roundIndex].notes = notes
    }
    
    func completeRound() {
        guard let round = currentRound, round.isCompleted else { return }
        
        roundHistory.append(round)
        playerStats.updateWith(round: round)
        currentRound = nil
        
        saveData()
    }
    
    func calculateHandicap() -> Double {
        // Simplified handicap calculation - use best 8 of last 20 rounds
        let recentRounds = Array(roundHistory.suffix(20))
        guard recentRounds.count >= 5 else { return 36.0 }
        
        let scoreDifferentials = recentRounds.map { round in
            Double(round.totalScore - round.totalPar)
        }.sorted()
        
        let countToUse = min(8, scoreDifferentials.count)
        let bestScores = Array(scoreDifferentials.prefix(countToUse))
        let average = bestScores.reduce(0, +) / Double(countToUse)
        
        return max(0, average * 0.96) // USGA formula simplification
    }
    
    private func saveData() {
        // In a real app, save to Core Data or UserDefaults
        if let encoded = try? JSONEncoder().encode(roundHistory) {
            UserDefaults.standard.set(encoded, forKey: "roundHistory")
        }
        if let encoded = try? JSONEncoder().encode(playerStats) {
            UserDefaults.standard.set(encoded, forKey: "playerStats")
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "roundHistory"),
           let decoded = try? JSONDecoder().decode([Round].self, from: data) {
            roundHistory = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "playerStats"),
           let decoded = try? JSONDecoder().decode(PlayerStats.self, from: data) {
            playerStats = decoded
        }
    }
}
