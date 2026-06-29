import Foundation
import SwiftData

enum AlcoholDrinkType: String, CaseIterable, Identifiable {
    case beer
    case wine
    case spirit
    case cocktail
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .beer: return "Beer"
        case .wine: return "Wine"
        case .spirit: return "Spirit"
        case .cocktail: return "Cocktail"
        case .other: return "Other"
        }
    }

    /// Approximate UK alcohol units for a single standard serving.
    var defaultUnits: Double {
        switch self {
        case .beer: return 2.0
        case .wine: return 1.5
        case .spirit: return 1.0
        case .cocktail: return 1.5
        case .other: return 1.0
        }
    }
}

@Model
final class AlcoholEntry {
    var id: UUID = UUID()
    var drinkType: String = AlcoholDrinkType.beer.rawValue
    var units: Double = 1.0
    var loggedAt: Date = Date()

    init(
        id: UUID = UUID(),
        drinkType: String = AlcoholDrinkType.beer.rawValue,
        units: Double = 1.0,
        loggedAt: Date = Date()
    ) {
        self.id = id
        self.drinkType = drinkType
        self.units = units
        self.loggedAt = loggedAt
    }
}
