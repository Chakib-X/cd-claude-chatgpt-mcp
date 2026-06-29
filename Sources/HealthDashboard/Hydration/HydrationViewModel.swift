import Foundation

enum HydrationViewModel {
    static func entries(_ entries: [HydrationEntry], on date: Date) -> [HydrationEntry] {
        let start = DateUtilities.startOfDay(date)
        let end = DateUtilities.endOfDay(date)
        return entries.filter { $0.loggedAt >= start && $0.loggedAt <= end }
    }

    static func totalMilliliters(_ entries: [HydrationEntry]) -> Int {
        entries.reduce(0) { $0 + $1.volumeMilliliters }
    }

    static func weekTotalMilliliters(_ entries: [HydrationEntry], weekStart: Date) -> Int {
        let weekEnd = DateUtilities.calendar.date(byAdding: .day, value: 7, to: weekStart) ?? weekStart
        return entries
            .filter { $0.loggedAt >= weekStart && $0.loggedAt < weekEnd }
            .reduce(0) { $0 + $1.volumeMilliliters }
    }
}
