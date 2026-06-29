import Foundation
import SwiftData

@Model
final class NutritionEntry {
    var id: UUID = UUID()
    var name: String = ""
    var calories: Int = 0
    var loggedAt: Date = Date()

    init(id: UUID = UUID(), name: String = "", calories: Int = 0, loggedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.calories = calories
        self.loggedAt = loggedAt
    }
}
