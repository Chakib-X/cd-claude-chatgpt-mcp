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

    /// Phase A/B: CloudKit is disabled (`.none`) to de-risk the very first build.
    /// Phase C flips this to `.automatic` once the iCloud capability has been
    /// added in Xcode and the model shapes have proven stable locally.
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
