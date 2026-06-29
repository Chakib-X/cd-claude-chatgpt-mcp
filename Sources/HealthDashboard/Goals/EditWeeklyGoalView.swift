import SwiftUI
import SwiftData

struct EditWeeklyGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \NekoMetric.displayName) private var allMetrics: [NekoMetric]

    let goal: WeeklyGoal?

    @State private var title: String
    @State private var metricType: WeeklyGoalMetricType
    @State private var targetValue: Double
    @State private var unit: String
    @State private var weekStartDate: Date
    @State private var linkedBaselineMetricKey: String?
    @State private var notes: String

    init(goal: WeeklyGoal? = nil) {
        self.goal = goal
        _title = State(initialValue: goal?.title ?? "")
        _metricType = State(initialValue: WeeklyGoalMetricType(rawValue: goal?.metricType ?? "") ?? .steps)
        _targetValue = State(initialValue: goal?.targetValue ?? 0)
        _unit = State(initialValue: goal?.unit ?? "")
        _weekStartDate = State(initialValue: goal?.weekStartDate ?? DateUtilities.startOfWeek(containing: Date()))
        _linkedBaselineMetricKey = State(initialValue: goal?.linkedBaselineMetricKey)
        _notes = State(initialValue: goal?.notes ?? "")
    }

    private var latestMetricsByKey: [NekoMetric] {
        var seenKeys = Set<String>()
        var result: [NekoMetric] = []
        for metric in allMetrics where !seenKeys.contains(metric.key) {
            seenKeys.insert(metric.key)
            result.append(metric)
        }
        return result
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("Title", text: $title)
                    Picker("Metric", selection: $metricType) {
                        ForEach(WeeklyGoalMetricType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    TextField("Target Value", value: $targetValue, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Unit", text: $unit)
                    DatePicker("Week Starting", selection: $weekStartDate, displayedComponents: .date)
                }

                Section("Baseline Link (optional)") {
                    Picker("Linked Neko Metric", selection: $linkedBaselineMetricKey) {
                        Text("None").tag(String?.none)
                        ForEach(latestMetricsByKey) { metric in
                            Text("\(metric.displayName) (\(metric.value, specifier: "%.1f") \(metric.unit))")
                                .tag(Optional(metric.key))
                        }
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle(goal == nil ? "New Goal" : "Edit Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.isEmpty)
                }
            }
        }
    }

    private func save() {
        if let goal {
            goal.title = title
            goal.metricType = metricType.rawValue
            goal.targetValue = targetValue
            goal.unit = unit
            goal.weekStartDate = DateUtilities.startOfWeek(containing: weekStartDate)
            goal.linkedBaselineMetricKey = linkedBaselineMetricKey
            goal.notes = notes
        } else {
            let newGoal = WeeklyGoal(
                title: title,
                metricType: metricType.rawValue,
                targetValue: targetValue,
                unit: unit,
                weekStartDate: DateUtilities.startOfWeek(containing: weekStartDate),
                linkedBaselineMetricKey: linkedBaselineMetricKey,
                notes: notes
            )
            modelContext.insert(newGoal)
        }
        dismiss()
    }
}
