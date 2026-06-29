import Foundation

enum GoalProgressCalculator {
    @MainActor
    static func currentValue(
        for goal: WeeklyGoal,
        nutritionEntries: [NutritionEntry],
        hydrationEntries: [HydrationEntry],
        supplements: [Supplement]
    ) async -> Double {
        let weekStart = goal.weekStartDate
        let weekEnd = DateUtilities.calendar.date(byAdding: .day, value: 7, to: weekStart) ?? weekStart

        switch WeeklyGoalMetricType(rawValue: goal.metricType) ?? .custom {
        case .steps:
            return (try? await HealthKitManager.shared.fetchStepCount(start: weekStart, end: weekEnd)) ?? 0
        case .workouts:
            let workouts = (try? await HealthKitManager.shared.fetchWorkouts(start: weekStart, end: weekEnd)) ?? []
            return Double(workouts.count)
        case .hydrationLiters:
            let milliliters = HydrationViewModel.weekTotalMilliliters(hydrationEntries, weekStart: weekStart)
            return Double(milliliters) / 1000
        case .calories:
            let weekEntries = nutritionEntries.filter { $0.loggedAt >= weekStart && $0.loggedAt < weekEnd }
            return Double(NutritionViewModel.totalCalories(weekEntries)) / 7
        case .supplementAdherence:
            return SupplementViewModel.adherencePercent(supplements)
        case .custom:
            return 0
        }
    }

    static func progressFraction(currentValue: Double, target: Double) -> Double {
        guard target > 0 else { return 0 }
        return min(currentValue / target, 1.0)
    }
}
