import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            PlayView()
                .tabItem { Label("Play", systemImage: "figure.golf") }

            CoursesView()
                .tabItem { Label("Courses", systemImage: "map") }

            MarketplaceView()
                .tabItem { Label("Market", systemImage: "cart") }

            OnCourseHomeView()
                .tabItem { Label("On-Course", systemImage: "cup.and.saucer") }

            ProfileView()
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
        // Keep tab bar solid, and paint behind it to the very edge
        .toolbarBackground(PGColors.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .background(PGColors.background.ignoresSafeArea())
    }
}

#Preview { RootView() }
