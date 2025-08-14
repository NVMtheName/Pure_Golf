
import Foundation
import CoreLocation

struct Round: Identifiable, Codable {
    let id = UUID()
    let courseId: UUID
    let courseName: String
    let date: Date
    var holes: [HoleScore]
    var totalScore: Int { holes.reduce(0) { $0 + $1.strokes } }
    var totalPar: Int { holes.reduce(0) { $0 + $1.par } }
    var scoreToPar: Int { totalScore - totalPar }
    var isCompleted: Bool { holes.count == 18 && holes.allSatisfy { $0.strokes > 0 } }
}

struct HoleScore: Identifiable, Codable {
    let id = UUID()
    let holeNumber: Int
    let par: Int
    let handicap: Int
    var strokes: Int = 0
    var putts: Int = 0
    var fairwayHit: Bool? = nil
    var greenInRegulation: Bool? = nil
    var shots: [Shot] = []
    var notes: String = ""
    
    var scoreToPar: Int { strokes - par }
    var scoreText: String {
        switch scoreToPar {
        case -2: return "Eagle"
        case -1: return "Birdie"
        case 0: return "Par"
        case 1: return "Bogey"
        case 2: return "Double Bogey"
        default: return scoreToPar > 0 ? "+\(scoreToPar)" : "\(scoreToPar)"
        }
    }
}

struct Shot: Identifiable, Codable {
    let id = UUID()
    let shotNumber: Int
    let club: String
    let distance: Double
    let accuracy: ShotAccuracy
    let lie: LieType
    let location: CLLocationCoordinate2D
    let timestamp: Date
    let notes: String?
    
    enum ShotAccuracy: String, CaseIterable, Codable {
        case perfect = "Perfect"
        case good = "Good"
        case okay = "Okay"
        case poor = "Poor"
        
        var emoji: String {
            switch self {
            case .perfect: return "🎯"
            case .good: return "✅"
            case .okay: return "⚠️"
            case .poor: return "❌"
            }
        }
    }
    
    enum LieType: String, CaseIterable, Codable {
        case tee = "Tee"
        case fairway = "Fairway"
        case rough = "Rough"
        case sand = "Sand"
        case green = "Green"
        case water = "Water"
        case trees = "Trees"
    }
}

struct PlayerStats: Codable {
    var totalRounds: Int = 0
    var averageScore: Double = 0
    var bestScore: Int = 200
    var currentHandicap: Double = 36.0
    var fairwaysHit: Double = 0
    var greensInRegulation: Double = 0
    var averagePutts: Double = 0
    var birdies: Int = 0
    var eagles: Int = 0
    var aces: Int = 0
    
    mutating func updateWith(round: Round) {
        totalRounds += 1
        let newTotal = (averageScore * Double(totalRounds - 1)) + Double(round.totalScore)
        averageScore = newTotal / Double(totalRounds)
        
        if round.totalScore < bestScore {
            bestScore = round.totalScore
        }
        
        // Update other stats
        let fairwaysHitCount = round.holes.compactMap { $0.fairwayHit }.filter { $0 }.count
        let girCount = round.holes.compactMap { $0.greenInRegulation }.filter { $0 }.count
        
        fairwaysHit = (fairwaysHit * Double(totalRounds - 1) + Double(fairwaysHitCount)) / Double(totalRounds)
        greensInRegulation = (greensInRegulation * Double(totalRounds - 1) + Double(girCount)) / Double(totalRounds)
        
        // Count birdies and eagles
        for hole in round.holes {
            switch hole.scoreToPar {
            case -2: eagles += 1
            case -1: birdies += 1
            case -3: aces += 1
            default: break
            }
        }
    }
}
