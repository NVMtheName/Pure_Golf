import SwiftUI

@MainActor
final class AppSession: ObservableObject {
    @AppStorage("isSignedIn") private var storedSignedIn: Bool = false
    @Published var isSignedIn: Bool = false

    init() {
        isSignedIn = storedSignedIn
    }

    func mockSignIn() {
        isSignedIn = true
        storedSignedIn = true
    }

    func signOut() {
        isSignedIn = false
        storedSignedIn = false
    }
}
