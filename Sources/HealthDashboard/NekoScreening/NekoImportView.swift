import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct NekoImportView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isImporterPresented = false
    @State private var reviewPayload: ReviewPayload?
    @State private var importError: String?
    @State private var savedMetricCount: Int?

    private struct ReviewPayload: Identifiable {
        let id = UUID()
        let sourceFileName: String
        let pdfData: Data
        let rawExtractedText: String
        let candidates: [NekoMetricCandidate]
    }

    var body: some View {
        VStack(spacing: 16) {
            if let savedMetricCount {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.green)
                Text("Screening Saved")
                    .font(.headline)
                Text(savedMetricCount == 1 ? "1 metric recorded." : "\(savedMetricCount) metrics recorded.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Image(systemName: "doc.text.viewfinder")
                    .font(.system(size: 40))
                    .foregroundStyle(.tint)
                Text("Import a Neko Health screening PDF. Text is extracted automatically, but you'll review and confirm every value before it's saved.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Text("Note: extraction only works on PDFs with selectable text, not scanned images. You can always add metrics manually on the next screen.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Choose PDF") {
                    isImporterPresented = true
                }
                .buttonStyle(.borderedProminent)

                if let importError {
                    Text(importError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .navigationTitle("Import Screening")
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [.pdf]) { result in
            handleImportResult(result)
        }
        .sheet(item: $reviewPayload) { payload in
            NekoReviewFormView(
                sourceFileName: payload.sourceFileName,
                pdfData: payload.pdfData,
                rawExtractedText: payload.rawExtractedText,
                candidates: payload.candidates,
                onSave: { metricCount in
                    savedMetricCount = metricCount
                }
            )
        }
    }

    private func handleImportResult(_ result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            importError = error.localizedDescription
        case .success(let url):
            let accessed = url.startAccessingSecurityScopedResource()
            defer {
                if accessed { url.stopAccessingSecurityScopedResource() }
            }
            guard let data = try? Data(contentsOf: url) else {
                importError = "Could not read the selected file."
                return
            }
            guard let document = PDFDocument(data: data) else {
                importError = "That file doesn't appear to be a valid PDF."
                return
            }
            importError = nil
            let extractedText = PDFTextExtractor.extractText(from: document)
            let candidates = NekoMetricParser.parse(text: extractedText)
            reviewPayload = ReviewPayload(
                sourceFileName: url.lastPathComponent,
                pdfData: data,
                rawExtractedText: extractedText,
                candidates: candidates
            )
        }
    }
}
