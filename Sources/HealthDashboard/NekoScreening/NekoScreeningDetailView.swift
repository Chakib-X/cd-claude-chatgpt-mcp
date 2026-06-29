import SwiftUI
import PDFKit

private struct PDFKitView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document == nil {
            uiView.document = PDFDocument(data: data)
        }
    }
}

struct NekoScreeningDetailView: View {
    let screening: NekoScreening

    var body: some View {
        List {
            Section("Metrics") {
                if let metrics = screening.metrics, !metrics.isEmpty {
                    ForEach(metrics.sorted(by: { $0.displayName < $1.displayName })) { metric in
                        HStack {
                            Text(metric.displayName)
                            Spacer()
                            Text("\(metric.value, specifier: "%.1f") \(metric.unit)")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Text("No metrics recorded for this screening.")
                        .foregroundStyle(.secondary)
                }
            }

            if let pdfData = screening.pdfData {
                Section("Source Document") {
                    PDFKitView(data: pdfData)
                        .frame(height: 500)
                }
            }

            if !screening.notes.isEmpty {
                Section("Notes") {
                    Text(screening.notes)
                }
            }
        }
        .navigationTitle(screening.screeningDate.formatted(date: .abbreviated, time: .omitted))
    }
}
