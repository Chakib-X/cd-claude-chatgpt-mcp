import SwiftUI
import SwiftData

struct NekoScreeningListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NekoScreening.screeningDate, order: .reverse) private var screenings: [NekoScreening]

    var body: some View {
        List {
            if screenings.isEmpty {
                ContentUnavailableView(
                    "No Screenings Yet",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Import your first Neko Health PDF to establish a baseline.")
                )
            } else {
                ForEach(screenings) { screening in
                    NavigationLink(value: screening) {
                        VStack(alignment: .leading) {
                            Text(screening.screeningDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text("\(screening.metrics?.count ?? 0) metrics · \(screening.sourceFileName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteScreenings)
            }
        }
        .navigationTitle("Neko Screenings")
        .navigationDestination(for: NekoScreening.self) { screening in
            NekoScreeningDetailView(screening: screening)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: NekoImportView()) {
                    Label("Import", systemImage: "plus")
                }
            }
        }
    }

    private func deleteScreenings(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(screenings[index])
        }
    }
}
