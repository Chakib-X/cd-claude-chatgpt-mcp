import Foundation
import SwiftData

@Model
final class HydrationEntry {
    var id: UUID = UUID()
    var volumeMilliliters: Int = 250
    var loggedAt: Date = Date()

    init(id: UUID = UUID(), volumeMilliliters: Int = 250, loggedAt: Date = Date()) {
        self.id = id
        self.volumeMilliliters = volumeMilliliters
        self.loggedAt = loggedAt
    }
}
