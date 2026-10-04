import SwiftUI

@main
struct LoopApp: App {
    init() {
        NotificationDelegate.shared.setUp()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(AppState.shared)
        }
    }
}
