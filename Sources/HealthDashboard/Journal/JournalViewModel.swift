import Foundation

enum JournalViewModel {
    static func entry(_ entries: [WellnessJournalEntry], on date: Date) -> WellnessJournalEntry? {
        let start = DateUtilities.startOfDay(date)
        return entries.first { $0.entryDate == start }
    }

    static func sortedByDateDescending(_ entries: [WellnessJournalEntry]) -> [WellnessJournalEntry] {
        entries.sorted { $0.entryDate > $1.entryDate }
    }
}
