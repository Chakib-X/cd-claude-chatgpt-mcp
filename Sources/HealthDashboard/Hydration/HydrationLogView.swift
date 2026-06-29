import SwiftUI
import SwiftData

struct HydrationLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allEntries: [HydrationEntry]

    @State private var showingCustomEntry = false
    @State private var customAmountText = ""

    private var todayEntries: [HydrationEntry] {
        HydrationViewModel.entries(allEntries, on: Date())
    }

    var body: some View {
        SectionCard(title: "Hydration") {
            Text(UnitFormatting.liters(fromMilliliters: HydrationViewModel.totalMilliliters(todayEntries)) + " today")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 10) {
                QuickAddButton(title: "+250ml", systemImage: "drop.fill", tint: .blue) {
                    log(250)
                }
                QuickAddButton(title: "+500ml", systemImage: "drop.fill", tint: .blue) {
                    log(500)
                }
                QuickAddButton(title: "Custom", systemImage: "plus.circle", tint: .blue) {
                    showingCustomEntry = true
                }
            }
        }
        .alert("Custom Amount", isPresented: $showingCustomEntry) {
            TextField("Milliliters", text: $customAmountText)
                .keyboardType(.numberPad)
            Button("Add") {
                if let amount = Int(customAmountText), amount > 0 {
                    log(amount)
                }
                customAmountText = ""
            }
            Button("Cancel", role: .cancel) {
                customAmountText = ""
            }
        }
    }

    private func log(_ milliliters: Int) {
        modelContext.insert(HydrationEntry(volumeMilliliters: milliliters, loggedAt: Date()))
    }
}
