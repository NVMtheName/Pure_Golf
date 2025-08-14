
import Foundation
import UserNotifications
import SwiftUI

@MainActor
final class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var hasPermission = false
    
    private init() {
        checkPermission()
    }
    
    func requestPermission() async {
        do {
            let permission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            hasPermission = permission
        } catch {
            hasPermission = false
        }
    }
    
    func scheduleInvitationNotification(from friend: String, course: String, teeTime: Date) {
        guard hasPermission else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Golf Invitation"
        content.body = "\(friend) invited you to play at \(course)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.hasPermission = settings.authorizationStatus == .authorized
            }
        }
    }
}
