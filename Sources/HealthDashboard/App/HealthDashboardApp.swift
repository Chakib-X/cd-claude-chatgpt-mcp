import SwiftUI

@main
struct HealthDashboardApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(AppContainer.shared)
    }
}
