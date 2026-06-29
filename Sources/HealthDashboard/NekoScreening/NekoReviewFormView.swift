import SwiftUI
import SwiftData

struct NekoReviewFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let sourceFileName: String
    let pdfData: Data
    let rawExtractedText: String
    let onSave: (Int) -> Void

    @State private var screeningDate: Date
    @State private var candidates: [NekoMetricCandidate]
    @State private var newMetricName: String = ""
    @State private var newMetricUnit: String = ""
    @State private var newMetricValue: String = ""

    init(sourceFileName: String, pdfData: Data, rawExtractedText: String, candidates: [NekoMetricCandidate], onSave: @escaping (Int) -> Void = { _ in }) {
        self.sourceFileName = sourceFileName
        self.pdfData = pdfData
        self.rawExtractedText = rawExtractedText
        self.onSave = onSave
        _screeningDate = State(initialValue: Date())
        _candidates = State(initialValue: candidates)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Screening Date") {
                    DatePicker("Date", selection: $screeningDate, displayedComponents: .date)
                }

                Section("Extracted Metrics") {
                    if candidates.isEmpty {
                        Text("No metrics were automatically detected. Add them manually below.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach($candidates) { $candidate in
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Metric name", text: $candidate.displayName)
                            HStack {
                                TextField("Value", value: $candidate.value, format: .number)
                                    .keyboardType(.decimalPad)
                                TextField("Unit", text: $candidate.unit)
                                Text(candidate.confidence == "extracted" ? "Auto" : "Manual")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                        candidates.remove(atOffsets: offsets)
                    }
                }

                Section("Add Custom Metric") {
                    TextField("Name", text: $newMetricName)
                    TextField("Unit", text: $newMetricUnit)
                    TextField("Value", text: $newMetricValue)
                        .keyboardType(.decimalPad)
                    Button("Add Metric") {
                        addCustomMetric()
                    }
                    .disabled(newMetricName.isEmpty || Double(newMetricValue) == nil)
                }
            }
            .navigationTitle("Review Screening")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func addCustomMetric() {
        guard let value = Double(newMetricValue) else { return }
        candidates.append(
            NekoMetricCandidate(
                key: "custom_\(UUID().uuidString)",
                displayName: newMetricName,
                unit: newMetricUnit,
                value: value,
                confidence: "manual"
            )
        )
        newMetricName = ""
        newMetricUnit = ""
        newMetricValue = ""
    }

    private func save() {
        let screening = NekoScreening(
            screeningDate: screeningDate,
            importedAt: Date(),
            sourceFileName: sourceFileName,
            pdfData: pdfData,
            rawExtractedText: rawExtractedText
        )
        modelContext.insert(screening)

        for candidate in candidates {
            let metric = NekoMetric(
                key: candidate.key,
                displayName: candidate.displayName,
                unit: candidate.unit,
                value: candidate.value,
                confidence: candidate.confidence,
                screening: screening
            )
            modelContext.insert(metric)
        }

        onSave(candidates.count)
        dismiss()
    }
}
