import SwiftUI

@main
struct PureGolfApp: App {
    @StateObject private var session = AppSession()
    @StateObject private var onCourseCart = OnCourseCartStore()

    init() {
        // Solid (non-translucent) native tab bar, matches app background
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = UIColor(PGColors.background)
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        UITabBar.appearance().isTranslucent = false

        // Solid (non-translucent) navigation bar (if any screens use it)
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = UIColor(PGColors.background)
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav

        // 🔑 Paint the actual OS window & all scroll containers behind SwiftUI.
        let bg = UIColor(PGColors.background)
        UIWindow.appearance().backgroundColor = bg
        UIScrollView.appearance().backgroundColor = bg
        UICollectionView.appearance().backgroundColor = bg
        UITableView.appearance().backgroundColor = .clear // Lists draw their own rows
    }

    var body: some View {
        Group {
            if session.isSignedIn {
                ContentView()
            } else {
                SignInView()
            }
        }
        .environmentObject(session)
        .environmentObject(CartStore())
        .environmentObject(onCourseCart)
        .statusBarHidden(true)
        .ignoresSafeArea(.all)
        .task {
            await NotificationService.shared.requestPermission()
        }
    }
}</old_str>
<new_str>@main
struct PureGolfApp: App {
    @StateObject private var session = AppSession()
    @StateObject private var onCourseCart = OnCourseCartStore()

    init() {
        // Solid (non-translucent) native tab bar, matches app background
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = UIColor(PGColors.background)
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        UITabBar.appearance().isTranslucent = false

        // Solid (non-translucent) navigation bar (if any screens use it)
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = UIColor(PGColors.background)
        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav

        // 🔑 Paint the actual OS window & all scroll containers behind SwiftUI.
        let bg = UIColor(PGColors.background)
        UIWindow.appearance().backgroundColor = bg
        UIScrollView.appearance().backgroundColor = bg
        UICollectionView.appearance().backgroundColor = bg
        UITableView.appearance().backgroundColor = .clear // Lists draw their own rows
    }

    var body: some Scene {
        WindowGroup {
            // Fill *everything* behind content (top + bottom safe areas)
            ZStack {
                PGColors.background.ignoresSafeArea()
                RootView()
                    .environmentObject(session)
                    .environmentObject(onCourseCart)
                    .tint(PGColors.accent)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
