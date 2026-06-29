import SwiftUI
import SwiftData

struct AddJournalEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var entryToEdit: WellnessJournalEntry?
    var date: Date = Date()

    @State private var energyLevel: Double = 3
    @State private var mood: Double = 3
    @State private var hasWorkoutSoreness = false
    @State private var sorenessLocation = ""
    @State private var sorenessSeverity: Double = 1
    @State private var hasOtherPain = false
    @State private var otherPainLocation = ""
    @State private var otherPainSeverity: Double = 1
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("How are you feeling?") {
                    VStack(alignment: .leading) {
                        Text("Energy: \(Int(energyLevel))/5")
                        Slider(value: $energyLevel, in: 1...5, step: 1)
                    }
                    VStack(alignment: .leading) {
                        Text("Mood: \(Int(mood))/5")
                        Slider(value: $mood, in: 1...5, step: 1)
                    }
                }

                Section("Workout Soreness") {
                    Toggle("Sore from a workout", isOn: $hasWorkoutSoreness)
                    if hasWorkoutSoreness {
                        TextField("Location (e.g. quads, shoulders)", text: $sorenessLocation)
                        VStack(alignment: .leading) {
                            Text("Severity: \(Int(sorenessSeverity))/5")
                            Slider(value: $sorenessSeverity, in: 1...5, step: 1)
                        }
                    }
                }

                Section("Other Pain") {
                    Toggle("Pain unrelated to working out", isOn: $hasOtherPain)
                    if hasOtherPain {
                        TextField("Location", text: $otherPainLocation)
                        VStack(alignment: .leading) {
                            Text("Severity: \(Int(otherPainSeverity))/5")
                            Slider(value: $otherPainSeverity, in: 1...5, step: 1)
                        }
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(entryToEdit == nil ? "Today's Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear(perform: populateIfEditing)
        }
    }

    private func populateIfEditing() {
        guard let entry = entryToEdit else { return }
        energyLevel = Double(entry.energyLevel)
        mood = Double(entry.mood)
        hasWorkoutSoreness = entry.hasWorkoutSoreness
        sorenessLocation = entry.sorenessLocation
        sorenessSeverity = Double(max(entry.sorenessSeverity, 1))
        hasOtherPain = entry.hasOtherPain
        otherPainLocation = entry.otherPainLocation
        otherPainSeverity = Double(max(entry.otherPainSeverity, 1))
        notes = entry.notes
    }

    private func save() {
        if let entry = entryToEdit {
            apply(to: entry)
        } else {
            let entry = WellnessJournalEntry(entryDate: DateUtilities.startOfDay(date))
            apply(to: entry)
            modelContext.insert(entry)
        }
        dismiss()
    }

    private func apply(to entry: WellnessJournalEntry) {
        entry.energyLevel = Int(energyLevel)
        entry.mood = Int(mood)
        entry.hasWorkoutSoreness = hasWorkoutSoreness
        entry.sorenessLocation = hasWorkoutSoreness ? sorenessLocation : ""
        entry.sorenessSeverity = hasWorkoutSoreness ? Int(sorenessSeverity) : 0
        entry.hasOtherPain = hasOtherPain
        entry.otherPainLocation = hasOtherPain ? otherPainLocation : ""
        entry.otherPainSeverity = hasOtherPain ? Int(otherPainSeverity) : 0
        entry.notes = notes
    }
}
