import Foundation
import SwiftData

enum SchemaContainer {
    static var schema: Schema {
        Schema([
            NekoScreening.self,
            NekoMetric.self,
            WeeklyGoal.self,
            NutritionEntry.self,
            FavoriteFood.self,
            Supplement.self,
            SupplementLog.self,
            HydrationEntry.self,
            AlcoholEntry.self,
            WellnessJournalEntry.self
        ])
    }

    /// CloudKit sync is enabled so logs/journal/goals/screenings survive the
    /// periodic reinstalls required by free Apple ID signing. The container
    /// identifier is derived from the iCloud capability configured in Xcode's
    /// Signing & Capabilities tab (see README.md), not hardcoded here.
    static func makeContainer() -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
