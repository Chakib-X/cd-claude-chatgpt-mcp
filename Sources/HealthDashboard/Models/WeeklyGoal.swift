import Foundation
import SwiftData

enum WeeklyGoalMetricType: String, CaseIterable, Identifiable {
    case steps
    case workouts
    case hydrationLiters
    case calories
    case supplementAdherence
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .steps: return "Steps"
        case .workouts: return "Workouts"
        case .hydrationLiters: return "Hydration (L)"
        case .calories: return "Calories"
        case .supplementAdherence: return "Supplement Adherence"
        case .custom: return "Custom"
        }
    }
}

@Model
final class WeeklyGoal {
    var id: UUID = UUID()
    var title: String = ""
    var metricType: String = WeeklyGoalMetricType.steps.rawValue
    var targetValue: Double = 0
    var unit: String = ""
    var weekStartDate: Date = Date()
    var linkedBaselineMetricKey: String? = nil
    var notes: String = ""

    init(
        id: UUID = UUID(),
        title: String = "",
        metricType: String = WeeklyGoalMetricType.steps.rawValue,
        targetValue: Double = 0,
        unit: String = "",
        weekStartDate: Date = Date(),
        linkedBaselineMetricKey: String? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.metricType = metricType
        self.targetValue = targetValue
        self.unit = unit
        self.weekStartDate = weekStartDate
        self.linkedBaselineMetricKey = linkedBaselineMetricKey
        self.notes = notes
    }
}
