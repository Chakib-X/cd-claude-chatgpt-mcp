import Foundation

enum AlcoholViewModel {
    static func entries(_ entries: [AlcoholEntry], on date: Date) -> [AlcoholEntry] {
        let start = DateUtilities.startOfDay(date)
        let end = DateUtilities.endOfDay(date)
        return entries.filter { $0.loggedAt >= start && $0.loggedAt <= end }
    }

    static func totalUnits(_ entries: [AlcoholEntry]) -> Double {
        entries.reduce(0) { $0 + $1.units }
    }
}
