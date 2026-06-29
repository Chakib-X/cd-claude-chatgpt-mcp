import SwiftUI
import SwiftData

struct WellnessJournalView: View {
    @Query private var allEntries: [WellnessJournalEntry]

    @State private var showingTodaySheet = false
    @State private var editingEntry: WellnessJournalEntry?

    private var todayEntry: WellnessJournalEntry? {
        JournalViewModel.entry(allEntries, on: Date())
    }

    private var history: [WellnessJournalEntry] {
        JournalViewModel.sortedByDateDescending(allEntries)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showingTodaySheet = true
                    } label: {
                        HStack {
                            Image(systemName: todayEntry == nil ? "plus.circle.fill" : "pencil.circle.fill")
                            Text(todayEntry == nil ? "Log today's entry" : "Edit today's entry")
                        }
                    }
                }

                Section("History") {
                    ForEach(history) { entry in
                        Button {
                            editingEntry = entry
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.entryDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.subheadline.weight(.semibold))
                                Text("Energy \(entry.energyLevel)/5 · Mood \(entry.mood)/5")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                if entry.hasWorkoutSoreness {
                                    Text("Workout soreness: \(entry.sorenessLocation) (\(entry.sorenessSeverity)/5)")
                                        .font(.caption)
                                        .foregroundStyle(.orange)
                                }
                                if entry.hasOtherPain {
                                    Text("Other pain: \(entry.otherPainLocation) (\(entry.otherPainSeverity)/5)")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Wellness Journal")
            .sheet(isPresented: $showingTodaySheet) {
                AddJournalEntryView(entryToEdit: todayEntry, date: Date())
            }
            .sheet(item: $editingEntry) { entry in
                AddJournalEntryView(entryToEdit: entry, date: entry.entryDate)
            }
        }
    }
}
