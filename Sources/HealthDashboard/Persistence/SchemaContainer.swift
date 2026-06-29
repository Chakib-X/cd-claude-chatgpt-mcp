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

    /// CloudKit sync is disabled: Apple restricts the iCloud/CloudKit capability
    /// to paid Developer Program teams, and this app signs with a free personal
    /// Apple ID. Data is local-only on each device and survives the periodic
    /// re-sign/reinstall required by free signing, but does not sync across
    /// devices or survive deleting the app.
    static func makeContainer() -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
