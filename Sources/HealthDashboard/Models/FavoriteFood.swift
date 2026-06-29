import Foundation
import SwiftData

@Model
final class FavoriteFood {
    var id: UUID = UUID()
    var name: String = ""
    var calories: Int = 0
    var sortOrder: Int = 0
    var useCount: Int = 0

    init(
        id: UUID = UUID(),
        name: String = "",
        calories: Int = 0,
        sortOrder: Int = 0,
        useCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.sortOrder = sortOrder
        self.useCount = useCount
    }
}
