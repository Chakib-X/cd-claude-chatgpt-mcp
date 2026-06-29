import SwiftUI
import SwiftData

struct SupplementListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Supplement.sortOrder) private var supplements: [Supplement]

    @State private var showingAddSheet = false
    @State private var editingSupplement: Supplement?

    var body: some View {
        List {
            ForEach(supplements) { supplement in
                Button {
                    editingSupplement = supplement
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(supplement.name)
                            if !supplement.isActive {
                                Text("Inactive")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        if !supplement.dose.isEmpty || !supplement.scheduleDescription.isEmpty {
                            Text("\(supplement.dose) · \(supplement.scheduleDescription)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .onDelete { offsets in
                for index in offsets {
                    modelContext.delete(supplements[index])
                }
            }
        }
        .navigationTitle("Supplements")
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
            EditSupplementView()
        }
        .sheet(item: $editingSupplement) { supplement in
            EditSupplementView(supplementToEdit: supplement)
        }
    }
}
