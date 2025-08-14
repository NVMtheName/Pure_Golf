import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: AppSession
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var onCourseCart: OnCourseCartStore
    @StateObject private var locationService = LocationService.shared

    var body: some View {
        TabView {
            PlayView()
                .tabItem { Label("Play", systemImage: "figure.golf") }

            CoursesView()
                .tabItem { Label("Courses", systemImage: "map") }

            MarketplaceView()
                .tabItem { Label("Market", systemImage: "bag") }

            OnCourseHomeView()
                .tabItem { Label("On‑Course", systemImage: "cup.and.saucer") }
                // Use a String badge to avoid the Int/nil type clash
                .badge(onCourseCart.count > 0 ? "\(onCourseCart.count)" : "")

            SwingView()
                .tabItem { Label("Swing", systemImage: "camera.viewfinder") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .pgBackground()
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppSession())
        .environmentObject(CartStore())
        .environmentObject(OnCourseCartStore())
}