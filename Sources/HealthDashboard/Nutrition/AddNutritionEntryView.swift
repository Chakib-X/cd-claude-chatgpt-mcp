import SwiftUI
import SwiftData

struct AddNutritionEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var caloriesText: String = ""
    @State private var saveAsFavorite: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal") {
                    TextField("Name", text: $name)
                    TextField("Calories", text: $caloriesText)
                        .keyboardType(.numberPad)
                }
                Section {
                    Toggle("Save as favorite for quick-add", isOn: $saveAsFavorite)
                }
            }
            .navigationTitle("Add Meal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let calories = Int(caloriesText) ?? 0
        let entry = NutritionEntry(name: name, calories: calories, loggedAt: Date())
        modelContext.insert(entry)

        if saveAsFavorite {
            let favorite = FavoriteFood(name: name, calories: calories)
            modelContext.insert(favorite)
        }

        dismiss()
    }
}
