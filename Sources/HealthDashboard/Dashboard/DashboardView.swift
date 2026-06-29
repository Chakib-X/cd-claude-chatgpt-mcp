import SwiftUI

/// Phase A placeholder — replaced with live HealthKit + SwiftData aggregation in Phase B,
/// and Neko baseline alignment in Phase C.
struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "heart.text.square")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                Text("Dashboard")
                    .font(.title2.bold())
                Text("Your fitness, nutrition, and wellness overview will appear here once HealthKit integration lands in Phase B.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
        }
    }
}
