import SwiftUI
import SwiftData
import Charts

private struct DailyValue: Identifiable {
    let id = UUID()
    let day: Date
    let value: Double
}

struct WeeklyTrendChartsView: View {
    @Query private var hydrationEntries: [HydrationEntry]
    @Query(sort: \NekoScreening.screeningDate, order: .reverse) private var screenings: [NekoScreening]

    @State private var dailySteps: [DailyValue] = []
    @State private var dailyRestingHeartRate: [DailyValue] = []

    private var last7Days: [Date] {
        (0..<7).map { DateUtilities.daysAgo(6 - $0) }
    }

    private var hydrationByDay: [DailyValue] {
        last7Days.map { day in
            let dayEntries = HydrationViewModel.entries(hydrationEntries, on: day)
            let liters = Double(HydrationViewModel.totalMilliliters(dayEntries)) / 1000
            return DailyValue(day: day, value: liters)
        }
    }

    private var restingHeartRateBaseline: Double? {
        screenings.first?.metrics?.first { $0.key == NekoMetricKey.restingHeartRate }?.value
    }

    var body: some View {
        VStack(spacing: 16) {
            SectionCard(title: "Steps (Last 7 Days)") {
                Chart(dailySteps) { item in
                    BarMark(
                        x: .value("Day", item.day, unit: .day),
                        y: .value("Steps", item.value)
                    )
                }
                .frame(height: 160)
            }

            SectionCard(title: "Hydration (Last 7 Days)") {
                Chart(hydrationByDay) { item in
                    LineMark(
                        x: .value("Day", item.day, unit: .day),
                        y: .value("Liters", item.value)
                    )
                    PointMark(
                        x: .value("Day", item.day, unit: .day),
                        y: .value("Liters", item.value)
                    )
                }
                .frame(height: 160)
            }

            SectionCard(title: "Resting Heart Rate vs Baseline") {
                Chart {
                    ForEach(dailyRestingHeartRate) { item in
                        LineMark(
                            x: .value("Day", item.day, unit: .day),
                            y: .value("BPM", item.value)
                        )
                    }
                    if let baseline = restingHeartRateBaseline {
                        RuleMark(y: .value("Baseline", baseline))
                            .foregroundStyle(.red)
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                            .annotation(position: .top, alignment: .leading) {
                                Text("Neko baseline: \(baseline, specifier: "%.0f") bpm")
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                            }
                    }
                }
                .frame(height: 160)
            }
        }
        .task {
            await loadHealthKitTrends()
        }
    }

    private func loadHealthKitTrends() async {
        var steps: [DailyValue] = []
        var restingHeartRate: [DailyValue] = []
        for day in last7Days {
            let start = DateUtilities.startOfDay(day)
            let end = DateUtilities.endOfDay(day)
            let stepCount = (try? await HealthKitManager.shared.fetchStepCount(start: start, end: end)) ?? 0
            steps.append(DailyValue(day: day, value: stepCount))
            if let hr = try? await HealthKitManager.shared.fetchAverageRestingHeartRate(start: start, end: end), let hr {
                restingHeartRate.append(DailyValue(day: day, value: hr))
            }
        }
        dailySteps = steps
        dailyRestingHeartRate = restingHeartRate
    }
}
