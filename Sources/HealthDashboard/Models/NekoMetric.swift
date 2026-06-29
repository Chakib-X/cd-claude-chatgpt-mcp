import Foundation
import SwiftData

@Model
final class NekoMetric {
    var id: UUID = UUID()
    var key: String = ""
    var displayName: String = ""
    var unit: String = ""
    var value: Double = 0
    var confidence: String = "manual"
    var screening: NekoScreening? = nil

    init(
        id: UUID = UUID(),
        key: String = "",
        displayName: String = "",
        unit: String = "",
        value: Double = 0,
        confidence: String = "manual",
        screening: NekoScreening? = nil
    ) {
        self.id = id
        self.key = key
        self.displayName = displayName
        self.unit = unit
        self.value = value
        self.confidence = confidence
        self.screening = screening
    }
}
