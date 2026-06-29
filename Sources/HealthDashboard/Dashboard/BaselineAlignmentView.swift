import SwiftUI

struct BaselineAlignmentView: View {
    let screening: NekoScreening
    @ObservedObject var dashboardViewModel: DashboardViewModel

    @State private var currentValues: [String: Double] = [:]

    private var comparableMetrics: [NekoMetric] {
        (screening.metrics ?? []).filter { metric in
            metric.key == NekoMetricKey.restingHeartRate ||
            metric.key == NekoMetricKey.bodyFatPercentage ||
            metric.key == NekoMetricKey.bodyWeight
        }
    }

    var body: some View {
        SectionCard(title: "Baseline Alignment") {
            if comparableMetrics.isEmpty {
                Text("No comparable live metrics found in your latest screening.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(comparableMetrics) { metric in
                    HStack {
                        Text(metric.displayName)
                        Spacer()
                        if let current = currentValues[metric.key] {
                            Text("\(UnitFormatting.oneDecimal(current)) now vs \(UnitFormatting.oneDecimal(metric.value)) baseline")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Baseline: \(UnitFormatting.oneDecimal(metric.value)) \(metric.unit)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
            }
        }
        .task {
            await loadCurrentValues()
        }
    }

    private func loadCurrentValues() async {
        var values: [String: Double] = [:]
        if let restingHeartRate = dashboardViewModel.latestRestingHeartRate {
            values[NekoMetricKey.restingHeartRate] = restingHeartRate
        }
        if let bodyFat = try? await HealthKitManager.shared.fetchLatestBodyFatPercentage() {
            values[NekoMetricKey.bodyFatPercentage] = bodyFat * 100
        }
        if let bodyMass = try? await HealthKitManager.shared.fetchLatestBodyMass() {
            values[NekoMetricKey.bodyWeight] = bodyMass
        }
        currentValues = values
    }
}
