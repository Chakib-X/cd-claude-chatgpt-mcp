import SwiftUI

/// Phase A placeholder — full goal CRUD + progress tracking lands in Phase C
/// once Neko baseline metrics exist to link against.
struct WeeklyGoalsListView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "target")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                Text("Weekly Goals")
                    .font(.title2.bold())
                Text("Goal setting tied to your Neko Health baseline arrives in Phase C.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Goals")
        }
    }
}
