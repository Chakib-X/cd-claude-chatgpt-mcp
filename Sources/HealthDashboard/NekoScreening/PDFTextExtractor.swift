import Foundation
import PDFKit

enum PDFTextExtractor {
    static func extractText(from document: PDFDocument) -> String {
        var fullText = ""
        for pageIndex in 0..<document.pageCount {
            guard let page = document.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        return fullText
    }
}
