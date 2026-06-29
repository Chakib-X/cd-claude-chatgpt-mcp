import SwiftUI
import SwiftData

struct FavoriteFoodsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteFood.sortOrder) private var favorites: [FavoriteFood]

    @State private var showingAddSheet = false
    @State private var newName = ""
    @State private var newCaloriesText = ""

    var body: some View {
        List {
            ForEach(favorites) { favorite in
                HStack {
                    VStack(alignment: .leading) {
                        Text(favorite.name)
                        Text("\(favorite.calories) kcal · used \(favorite.useCount)x")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { offsets in
                for index in offsets {
                    modelContext.delete(favorites[index])
                }
            }
        }
        .navigationTitle("Favorite Foods")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                Form {
                    TextField("Name", text: $newName)
                    TextField("Calories", text: $newCaloriesText)
                        .keyboardType(.numberPad)
                }
                .navigationTitle("New Favorite")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            resetForm()
                            showingAddSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            addFavorite()
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }

    private func addFavorite() {
        let favorite = FavoriteFood(
            name: newName,
            calories: Int(newCaloriesText) ?? 0,
            sortOrder: favorites.count
        )
        modelContext.insert(favorite)
        resetForm()
        showingAddSheet = false
    }

    private func resetForm() {
        newName = ""
        newCaloriesText = ""
    }
}
