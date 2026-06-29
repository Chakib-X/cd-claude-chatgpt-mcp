import Foundation
import SwiftData

@Model
final class NekoScreening {
    var id: UUID = UUID()
    var screeningDate: Date = Date()
    var importedAt: Date = Date()
    var sourceFileName: String = ""
    @Attribute(.externalStorage) var pdfData: Data? = nil
    var rawExtractedText: String = ""
    var notes: String = ""

    @Relationship(deleteRule: .cascade, inverse: \NekoMetric.screening)
    var metrics: [NekoMetric]? = []

    init(
        id: UUID = UUID(),
        screeningDate: Date = Date(),
        importedAt: Date = Date(),
        sourceFileName: String = "",
        pdfData: Data? = nil,
        rawExtractedText: String = "",
        notes: String = ""
    ) {
        self.id = id
        self.screeningDate = screeningDate
        self.importedAt = importedAt
        self.sourceFileName = sourceFileName
        self.pdfData = pdfData
        self.rawExtractedText = rawExtractedText
        self.notes = notes
    }
}
