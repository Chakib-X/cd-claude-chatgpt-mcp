import SwiftUI
import SwiftData

struct NutritionLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteFood.sortOrder) private var favorites: [FavoriteFood]
    @Query private var allEntries: [NutritionEntry]

    @State private var showingAddSheet = false

    private var todayEntries: [NutritionEntry] {
        NutritionViewModel.entries(allEntries, on: Date())
    }

    var body: some View {
        SectionCard(title: "Nutrition") {
            HStack {
                Text("\(NutritionViewModel.totalCalories(todayEntries)) kcal today")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            }

            if !favorites.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(favorites) { favorite in
                            QuickAddButton(
                                title: favorite.name,
                                systemImage: "fork.knife",
                                tint: .orange
                            ) {
                                logFavorite(favorite)
                            }
                        }
                    }
                }
            }

            if todayEntries.isEmpty {
                Text("No meals logged today.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(todayEntries.prefix(5)) { entry in
                    HStack {
                        Text(entry.name)
                        Spacer()
                        Text("\(entry.calories) kcal")
                            .foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddNutritionEntryView()
        }
    }

    private func logFavorite(_ favorite: FavoriteFood) {
        let entry = NutritionEntry(name: favorite.name, calories: favorite.calories, loggedAt: Date())
        modelContext.insert(entry)
        favorite.useCount += 1
    }
}
