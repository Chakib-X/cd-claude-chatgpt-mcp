import SwiftUI
import SwiftData

struct AlcoholLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allEntries: [AlcoholEntry]

    private var todayEntries: [AlcoholEntry] {
        AlcoholViewModel.entries(allEntries, on: Date())
    }

    var body: some View {
        SectionCard(title: "Alcohol") {
            Text(UnitFormatting.units(AlcoholViewModel.totalUnits(todayEntries)) + " today")
                .font(.subheadline.weight(.semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(AlcoholDrinkType.allCases) { drinkType in
                        QuickAddButton(
                            title: drinkType.displayName,
                            systemImage: "wineglass.fill",
                            tint: .purple
                        ) {
                            log(drinkType)
                        }
                    }
                }
            }
        }
    }

    private func log(_ drinkType: AlcoholDrinkType) {
        let entry = AlcoholEntry(drinkType: drinkType.rawValue, units: drinkType.defaultUnits, loggedAt: Date())
        modelContext.insert(entry)
    }
}
