import SwiftUI

struct TodaySummaryCard: View {
    let steps: Double
    let activeEnergy: Double
    let workoutCount: Int
    let restingHeartRate: Double?

    var body: some View {
        SectionCard(title: "Today's Activity") {
            HStack {
                metric(value: "\(Int(steps))", label: "Steps", systemImage: "figure.walk")
                Spacer()
                metric(value: "\(Int(activeEnergy)) kcal", label: "Active Energy", systemImage: "flame.fill")
                Spacer()
                metric(value: "\(workoutCount)", label: "Workouts", systemImage: "figure.run")
            }
            if let restingHeartRate {
                Text("Resting HR: \(Int(restingHeartRate)) bpm")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func metric(value: String, label: String, systemImage: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .foregroundStyle(.tint)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}
