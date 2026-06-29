import Foundation
import SwiftData

@Model
final class SupplementLog {
    var id: UUID = UUID()
    var takenAt: Date = Date()
    var logDate: Date = Date()
    var supplement: Supplement? = nil

    init(
        id: UUID = UUID(),
        takenAt: Date = Date(),
        logDate: Date = Date(),
        supplement: Supplement? = nil
    ) {
        self.id = id
        self.takenAt = takenAt
        self.logDate = logDate
        self.supplement = supplement
    }
}
