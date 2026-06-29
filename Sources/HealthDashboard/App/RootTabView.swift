import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }
            LogTabView()
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }
            WeeklyGoalsListView()
                .tabItem { Label("Goals", systemImage: "target") }
            WellnessJournalView()
                .tabItem { Label("Journal", systemImage: "book.fill") }
            MoreTabView()
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
    }
}
