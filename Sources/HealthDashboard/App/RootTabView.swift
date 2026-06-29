import SwiftUI

struct RootTabView: View {
    @AppStorage("hasRequestedHealthKitAuth") private var hasRequestedHealthKitAuth = false
    @State private var showingHealthKitOnboarding = false

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
        .onAppear {
            if !hasRequestedHealthKitAuth {
                showingHealthKitOnboarding = true
            }
        }
        .sheet(isPresented: $showingHealthKitOnboarding, onDismiss: {
            hasRequestedHealthKitAuth = true
        }) {
            VStack(spacing: 20) {
                Text("Welcome")
                    .font(.title.bold())
                HealthKitAuthorizationView()
                Button("Continue") {
                    showingHealthKitOnboarding = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .interactiveDismissDisabled(false)
        }
    }
}
