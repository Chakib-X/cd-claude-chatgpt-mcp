import Foundation

enum NutritionViewModel {
    static func entries(_ entries: [NutritionEntry], on date: Date) -> [NutritionEntry] {
        let start = DateUtilities.startOfDay(date)
        let end = DateUtilities.endOfDay(date)
        return entries
            .filter { $0.loggedAt >= start && $0.loggedAt <= end }
            .sorted { $0.loggedAt > $1.loggedAt }
    }

    static func totalCalories(_ entries: [NutritionEntry]) -> Int {
        entries.reduce(0) { $0 + $1.calories }
    }
}
