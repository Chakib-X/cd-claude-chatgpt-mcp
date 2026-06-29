import Foundation

enum SupplementViewModel {
    static func isTakenToday(_ supplement: Supplement, today: Date = Date()) -> Bool {
        let start = DateUtilities.startOfDay(today)
        return (supplement.logs ?? []).contains { $0.logDate == start }
    }

    static func todayLog(_ supplement: Supplement, today: Date = Date()) -> SupplementLog? {
        let start = DateUtilities.startOfDay(today)
        return (supplement.logs ?? []).first { $0.logDate == start }
    }

    static func adherencePercent(_ supplements: [Supplement], on date: Date = Date()) -> Double {
        let active = supplements.filter(\.isActive)
        guard !active.isEmpty else { return 0 }
        let takenCount = active.filter { isTakenToday($0, today: date) }.count
        return Double(takenCount) / Double(active.count) * 100
    }
}
