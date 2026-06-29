import SwiftUI
import SwiftData

struct DailySupplementChecklistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Supplement> { $0.isActive }, sort: \Supplement.sortOrder)
    private var activeSupplements: [Supplement]

    var body: some View {
        SectionCard(title: "Supplements") {
            if activeSupplements.isEmpty {
                Text("No active supplements. Add some from the More tab.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(activeSupplements) { supplement in
                    Button {
                        toggle(supplement)
                    } label: {
                        HStack {
                            Image(systemName: SupplementViewModel.isTakenToday(supplement) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(SupplementViewModel.isTakenToday(supplement) ? .green : .secondary)
                            VStack(alignment: .leading) {
                                Text(supplement.name)
                                if !supplement.dose.isEmpty {
                                    Text(supplement.dose)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }

    private func toggle(_ supplement: Supplement) {
        if let existingLog = SupplementViewModel.todayLog(supplement) {
            modelContext.delete(existingLog)
        } else {
            let log = SupplementLog(takenAt: Date(), logDate: DateUtilities.startOfDay(Date()), supplement: supplement)
            modelContext.insert(log)
        }
    }
}
