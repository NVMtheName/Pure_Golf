
import SwiftUI

struct SocialView: View {
    @StateObject private var socialService = SocialService.shared
    @StateObject private var locationService = LocationService.shared
    @State private var showingInviteSheet = false
    @State private var selectedFriend: Friend?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Social")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Pending Invitations
                    if !socialService.pendingInvitations.isEmpty {
                        invitationsSection
                    }
                    
                    // Nearby Friends
                    nearbyFriendsSection
                    
                    // All Friends
                    allFriendsSection
                    
                    Spacer(minLength: 16)
                }
                .padding(.horizontal)
            }
        }
        .pgBackground()
        .sheet(isPresented: $showingInviteSheet) {
            if let friend = selectedFriend {
                InviteFriendSheet(friend: friend) {
                    showingInviteSheet = false
                    selectedFriend = nil
                }
            }
        }
        .onAppear {
            refreshNearbyFriends()
        }
    }
    
    private var invitationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pending Invitations")
                .font(.headline)
                .foregroundStyle(PGColors.text)
            
            ForEach(socialService.pendingInvitations) { invitation in
                InvitationCard(invitation: invitation) { response in
                    socialService.respondToInvitation(invitation, response: response)
                }
            }
        }
    }
    
    private var nearbyFriendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Nearby Friends")
                    .font(.headline)
                    .foregroundStyle(PGColors.text)
                
                Spacer()
                
                Button("Refresh") {
                    refreshNearbyFriends()
                }
                .font(.caption)
                .foregroundStyle(PGColors.accent)
            }
            
            if socialService.nearbyFriends.isEmpty {
                PGCard {
                    Text("No friends nearby")
                        .foregroundStyle(PGColors.subtext)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            } else {
                ForEach(socialService.nearbyFriends) { nearbyFriend in
                    NearbyFriendCard(nearbyFriend: nearbyFriend) {
                        selectedFriend = nearbyFriend.friend
                        showingInviteSheet = true
                    }
                }
            }
        }
    }
    
    private var allFriendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Friends")
                .font(.headline)
                .foregroundStyle(PGColors.text)
            
            ForEach(socialService.friends) { friend in
                FriendCard(friend: friend) {
                    selectedFriend = friend
                    showingInviteSheet = true
                }
            }
        }
    }
    
    private func refreshNearbyFriends() {
        guard let location = locationService.lastLocation else {
            locationService.requestOneShotLocation()
            return
        }
        socialService.findNearbyFriends(userLocation: location)
    }
}

struct NearbyFriendCard: View {
    let nearbyFriend: NearbyFriend
    let onInvite: () -> Void
    
    var body: some View {
        PGCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: nearbyFriend.friend.avatar)
                            .font(.title2)
                            .foregroundStyle(PGColors.accent)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(nearbyFriend.friend.name)
                                .font(.headline)
                                .foregroundStyle(PGColors.text)
                            
                            Text("HCP \(nearbyFriend.friend.handicap) • \(nearbyFriend.distanceText) away")
                                .font(.caption)
                                .foregroundStyle(PGColors.subtext)
                        }
                        
                        Spacer()
                        
                        if nearbyFriend.isOnCourse {
                            VStack(alignment: .trailing, spacing: 2) {
                                Image(systemName: "flag.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                                Text("On Course")
                                    .font(.caption2)
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                    
                    if let course = nearbyFriend.currentCourse {
                        Text("Playing at \(course)")
                            .font(.caption)
                            .foregroundStyle(PGColors.accent)
                            .padding(.top, 2)
                    }
                }
                
                Button("Invite") {
                    onInvite()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(PGColors.accent)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

struct FriendCard: View {
    let friend: Friend
    let onInvite: () -> Void
    
    var body: some View {
        PGCard {
            HStack {
                Image(systemName: friend.avatar)
                    .font(.title2)
                    .foregroundStyle(PGColors.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(friend.name)
                        .font(.headline)
                        .foregroundStyle(PGColors.text)
                    
                    Text("Handicap \(friend.handicap)")
                        .font(.caption)
                        .foregroundStyle(PGColors.subtext)
                }
                
                Spacer()
                
                if friend.isOnCourse {
                    VStack(alignment: .trailing, spacing: 2) {
                        Image(systemName: "flag.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                        Text("On Course")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                    .padding(.trailing, 8)
                }
                
                Button("Invite") {
                    onInvite()
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(PGColors.accent)
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

struct InvitationCard: View {
    let invitation: PlayInvitation
    let onRespond: (InvitationStatus) -> Void
    
    var body: some View {
        PGCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Invitation from \(invitation.from)")
                        .font(.headline)
                        .foregroundStyle(PGColors.text)
                    
                    Spacer()
                    
                    Text(invitation.status.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(invitation.status.color.opacity(0.2))
                        .foregroundStyle(invitation.status.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                Text("\(invitation.course) • \(formatDate(invitation.teeTime))")
                    .font(.subheadline)
                    .foregroundStyle(PGColors.subtext)
                
                if let message = invitation.message {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(PGColors.text)
                        .padding(.top, 4)
                }
                
                if invitation.status == .pending {
                    HStack(spacing: 12) {
                        Button("Accept") {
                            onRespond(.accepted)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Decline") {
                            onRespond(.declined)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct InviteFriendSheet: View {
    let friend: Friend
    let onDismiss: () -> Void
    
    @State private var selectedCourse = "Pacific Dunes"
    @State private var selectedDate = Date()
    @State private var message = ""
    @StateObject private var socialService = SocialService.shared
    
    private let courses = ["Pacific Dunes", "Pebble Beach", "Spyglass Hill", "Bethpage Black"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Invite Details") {
                    HStack {
                        Text("Friend:")
                        Spacer()
                        Text(friend.name)
                            .foregroundStyle(PGColors.subtext)
                    }
                    
                    Picker("Course", selection: $selectedCourse) {
                        ForEach(courses, id: \.self) { course in
                            Text(course).tag(course)
                        }
                    }
                    
                    DatePicker("Tee Time", selection: $selectedDate, in: Date()...)
                }
                
                Section("Message (Optional)") {
                    TextField("Add a personal message...", text: $message, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Invite to Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        socialService.sendPlayInvitation(
                            to: friend,
                            course: selectedCourse,
                            teeTime: selectedDate,
                            message: message.isEmpty ? nil : message
                        )
                        onDismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview { SocialView() }
