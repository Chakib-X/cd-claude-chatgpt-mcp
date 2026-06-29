import SwiftUI
import SwiftData

struct EditSupplementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var supplementToEdit: Supplement?

    @State private var name: String = ""
    @State private var dose: String = ""
    @State private var scheduleDescription: String = ""
    @State private var isActive: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Dose (e.g. 1000mg)", text: $dose)
                TextField("Schedule (e.g. Daily with breakfast)", text: $scheduleDescription)
                Toggle("Active", isOn: $isActive)
            }
            .navigationTitle(supplementToEdit == nil ? "New Supplement" : "Edit Supplement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: populateIfEditing)
        }
    }

    private func populateIfEditing() {
        guard let supplement = supplementToEdit else { return }
        name = supplement.name
        dose = supplement.dose
        scheduleDescription = supplement.scheduleDescription
        isActive = supplement.isActive
    }

    private func save() {
        if let supplement = supplementToEdit {
            supplement.name = name
            supplement.dose = dose
            supplement.scheduleDescription = scheduleDescription
            supplement.isActive = isActive
        } else {
            let supplement = Supplement(
                name: name,
                dose: dose,
                scheduleDescription: scheduleDescription,
                isActive: isActive
            )
            modelContext.insert(supplement)
        }
        dismiss()
    }
}
