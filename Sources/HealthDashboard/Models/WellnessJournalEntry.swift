import Foundation
import SwiftData

@Model
final class WellnessJournalEntry {
    var id: UUID = UUID()
    var entryDate: Date = Date()
    var energyLevel: Int = 3
    var mood: Int = 3
    var hasWorkoutSoreness: Bool = false
    var sorenessLocation: String = ""
    var sorenessSeverity: Int = 0
    var hasOtherPain: Bool = false
    var otherPainLocation: String = ""
    var otherPainSeverity: Int = 0
    var notes: String = ""

    init(
        id: UUID = UUID(),
        entryDate: Date = Date(),
        energyLevel: Int = 3,
        mood: Int = 3,
        hasWorkoutSoreness: Bool = false,
        sorenessLocation: String = "",
        sorenessSeverity: Int = 0,
        hasOtherPain: Bool = false,
        otherPainLocation: String = "",
        otherPainSeverity: Int = 0,
        notes: String = ""
    ) {
        self.id = id
        self.entryDate = entryDate
        self.energyLevel = energyLevel
        self.mood = mood
        self.hasWorkoutSoreness = hasWorkoutSoreness
        self.sorenessLocation = sorenessLocation
        self.sorenessSeverity = sorenessSeverity
        self.hasOtherPain = hasOtherPain
        self.otherPainLocation = otherPainLocation
        self.otherPainSeverity = otherPainSeverity
        self.notes = notes
    }
}
