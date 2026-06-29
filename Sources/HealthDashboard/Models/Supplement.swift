import Foundation
import SwiftData

@Model
final class Supplement {
    var id: UUID = UUID()
    var name: String = ""
    var dose: String = ""
    var scheduleDescription: String = ""
    var isActive: Bool = true
    var sortOrder: Int = 0

    @Relationship(deleteRule: .cascade, inverse: \SupplementLog.supplement)
    var logs: [SupplementLog]? = []

    init(
        id: UUID = UUID(),
        name: String = "",
        dose: String = "",
        scheduleDescription: String = "",
        isActive: Bool = true,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.dose = dose
        self.scheduleDescription = scheduleDescription
        self.isActive = isActive
        self.sortOrder = sortOrder
    }
}
