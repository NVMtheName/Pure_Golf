import Foundation

actor ShotLoggingService {
    static let shared = ShotLoggingService()
    private init() {}

    struct Entry: Codable {
        var ts: Date
        var hole: Int
        var strokes: Int
        var notes: String
    }

    // In-memory store for now. Replace with persistence.
    private var log: [Entry] = []

    func save(hole: Int, strokes: Int, notes: String) async {
        let entry = Entry(ts: Date(), hole: hole, strokes: strokes, notes: notes)
        log.append(entry)
    }

    func all() -> [Entry] { log }
}
