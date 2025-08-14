
import Foundation
import CoreLocation
import SwiftUI

@MainActor
final class SocialService: ObservableObject {
    static let shared = SocialService()
    
    @Published var friends: [Friend] = []
    @Published var nearbyFriends: [NearbyFriend] = []
    @Published var pendingInvitations: [PlayInvitation] = []
    @Published var sentInvitations: [PlayInvitation] = []
    
    private init() {
        loadMockData()
    }
    
    // MARK: - Friend Discovery
    func findNearbyFriends(userLocation: CLLocation) {
        // In a real app, this would query your backend API
        let mockNearbyFriends = friends.compactMap { friend -> NearbyFriend? in
            guard let friendLocation = friend.currentLocation else { return nil }
            let distance = userLocation.distance(from: friendLocation)
            
            // Only show friends within 50 miles
            if distance <= 50000 { // 50km in meters
                return NearbyFriend(
                    friend: friend,
                    distance: distance,
                    currentCourse: friend.currentCourse,
                    isOnCourse: friend.isOnCourse
                )
            }
            return nil
        }
        
        nearbyFriends = mockNearbyFriends.sorted { $0.distance < $1.distance }
    }
    
    // MARK: - Invitations
    func sendPlayInvitation(to friend: Friend, course: String, teeTime: Date, message: String?) {
        let invitation = PlayInvitation(
            id: UUID(),
            from: "You", // In real app, this would be current user
            to: friend.name,
            course: course,
            teeTime: teeTime,
            message: message,
            status: .pending
        )
        
        sentInvitations.append(invitation)
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // In real app, this would be handled by push notifications
            self.simulateInvitationResponse(invitation)
        }
    }
    
    func respondToInvitation(_ invitation: PlayInvitation, response: InvitationStatus) {
        if let index = pendingInvitations.firstIndex(where: { $0.id == invitation.id }) {
            pendingInvitations[index].status = response
            
            // Move to appropriate list after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.pendingInvitations.removeAll { $0.id == invitation.id }
            }
        }
    }
    
    private func simulateInvitationResponse(_ invitation: PlayInvitation) {
        // Simulate random responses for demo
        let responses: [InvitationStatus] = [.accepted, .declined]
        let randomResponse = responses.randomElement() ?? .declined
        
        if let index = sentInvitations.firstIndex(where: { $0.id == invitation.id }) {
            sentInvitations[index].status = randomResponse
        }
    }
    
    private func loadMockData() {
        friends = [
            Friend(name: "Adam Wilson", handicap: 12, avatar: "person.circle.fill", 
                   currentLocation: CLLocation(latitude: 37.7749, longitude: -122.4194),
                   currentCourse: "Pacific Dunes", isOnCourse: true),
            Friend(name: "Sarah Chen", handicap: 8, avatar: "person.circle.fill",
                   currentLocation: CLLocation(latitude: 37.7849, longitude: -122.4094),
                   currentCourse: "Pebble Beach", isOnCourse: true),
            Friend(name: "Mike Johnson", handicap: 15, avatar: "person.circle.fill",
                   currentLocation: CLLocation(latitude: 37.7649, longitude: -122.4294),
                   currentCourse: nil, isOnCourse: false),
            Friend(name: "Emily Davis", handicap: 6, avatar: "person.circle.fill",
                   currentLocation: CLLocation(latitude: 37.7549, longitude: -122.4394),
                   currentCourse: "Spyglass Hill", isOnCourse: true)
        ]
        
        // Mock pending invitations
        pendingInvitations = [
            PlayInvitation(
                from: "Adam Wilson",
                to: "You",
                course: "Pacific Dunes",
                teeTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                message: "Want to play a round tomorrow morning?",
                status: .pending
            )
        ]
    }
}
