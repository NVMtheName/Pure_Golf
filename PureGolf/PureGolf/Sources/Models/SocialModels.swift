
import Foundation
import CoreLocation

struct Friend: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let handicap: Int
    let avatar: String
    let currentLocation: CLLocation?
    let currentCourse: String?
    let isOnCourse: Bool
    
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct NearbyFriend: Identifiable {
    let id = UUID()
    let friend: Friend
    let distance: Double // in meters
    let currentCourse: String?
    let isOnCourse: Bool
    
    var distanceText: String {
        let miles = distance / 1609.34
        return String(format: "%.1f mi", miles)
    }
}

struct PlayInvitation: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let course: String
    let teeTime: Date
    let message: String?
    var status: InvitationStatus
    
    init(id: UUID = UUID(), from: String, to: String, course: String, teeTime: Date, message: String?, status: InvitationStatus) {
        self.id = id
        self.from = from
        self.to = to
        self.course = course
        self.teeTime = teeTime
        self.message = message
        self.status = status
    }
}

enum InvitationStatus: String, CaseIterable {
    case pending = "Pending"
    case accepted = "Accepted"
    case declined = "Declined"
    case expired = "Expired"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .accepted: return .green
        case .declined: return .red
        case .expired: return .gray
        }
    }
}

import SwiftUI
