import Foundation

enum NekoMetricKey {
    static let bloodPressureSystolic = "bloodPressureSystolic"
    static let bloodPressureDiastolic = "bloodPressureDiastolic"
    static let bodyFatPercentage = "bodyFatPercentage"
    static let totalCholesterol = "totalCholesterol"
    static let ldlCholesterol = "ldlCholesterol"
    static let hdlCholesterol = "hdlCholesterol"
    static let triglycerides = "triglycerides"
    static let restingHeartRate = "restingHeartRate"
    static let vo2Max = "vo2Max"
    static let bodyWeight = "bodyWeight"
    static let waistCircumference = "waistCircumference"
}

struct NekoMetricCandidate: Identifiable {
    let id = UUID()
    var key: String
    var displayName: String
    var unit: String
    var value: Double
    var confidence: String
}

private struct MetricRule {
    let key: String
    let displayName: String
    let unit: String
    let aliases: [String]
}

enum NekoMetricParser {
    private static let rules: [MetricRule] = [
        MetricRule(key: NekoMetricKey.bodyFatPercentage, displayName: "Body Fat", unit: "%",
                   aliases: ["body fat percentage", "body fat %", "body fat"]),
        MetricRule(key: NekoMetricKey.totalCholesterol, displayName: "Total Cholesterol", unit: "mmol/L",
                   aliases: ["total cholesterol", "cholesterol, total", "cholesterol total"]),
        MetricRule(key: NekoMetricKey.ldlCholesterol, displayName: "LDL Cholesterol", unit: "mmol/L",
                   aliases: ["ldl cholesterol", "ldl-c", "ldl"]),
        MetricRule(key: NekoMetricKey.hdlCholesterol, displayName: "HDL Cholesterol", unit: "mmol/L",
                   aliases: ["hdl cholesterol", "hdl-c", "hdl"]),
        MetricRule(key: NekoMetricKey.triglycerides, displayName: "Triglycerides", unit: "mmol/L",
                   aliases: ["triglycerides", "tg"]),
        MetricRule(key: NekoMetricKey.restingHeartRate, displayName: "Resting Heart Rate", unit: "bpm",
                   aliases: ["resting heart rate", "resting hr", "heart rate at rest"]),
        MetricRule(key: NekoMetricKey.vo2Max, displayName: "VO2 Max", unit: "ml/kg/min",
                   aliases: ["vo2max", "vo2 max", "vo₂max", "vo₂ max"]),
        MetricRule(key: NekoMetricKey.bodyWeight, displayName: "Body Weight", unit: "kg",
                   aliases: ["body weight", "weight"]),
        MetricRule(key: NekoMetricKey.waistCircumference, displayName: "Waist Circumference", unit: "cm",
                   aliases: ["waist circumference", "waist"])
    ]

    static func parse(text: String) -> [NekoMetricCandidate] {
        var candidates: [NekoMetricCandidate] = []
        candidates.append(contentsOf: parseBloodPressure(text: text))

        let lowercasedText = text.lowercased()
        for rule in rules {
            guard let value = firstNumericValue(forAliases: rule.aliases, in: lowercasedText, originalText: text) else { continue }
            candidates.append(
                NekoMetricCandidate(
                    key: rule.key,
                    displayName: rule.displayName,
                    unit: rule.unit,
                    value: value,
                    confidence: "extracted"
                )
            )
        }
        return candidates
    }

    private static func parseBloodPressure(text: String) -> [NekoMetricCandidate] {
        guard let regex = try? NSRegularExpression(pattern: "(\\d{2,3})\\s*/\\s*(\\d{2,3})") else { return [] }
        let nsText = text as NSString
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsText.length))

        for match in matches {
            guard match.numberOfRanges == 3 else { continue }
            let systolicString = nsText.substring(with: match.range(at: 1))
            let diastolicString = nsText.substring(with: match.range(at: 2))
            guard let systolic = Double(systolicString), let diastolic = Double(diastolicString) else { continue }
            guard systolic > diastolic, systolic >= 70, systolic <= 220, diastolic >= 40, diastolic <= 150 else { continue }

            return [
                NekoMetricCandidate(
                    key: NekoMetricKey.bloodPressureSystolic,
                    displayName: "Blood Pressure (Systolic)",
                    unit: "mmHg",
                    value: systolic,
                    confidence: "extracted"
                ),
                NekoMetricCandidate(
                    key: NekoMetricKey.bloodPressureDiastolic,
                    displayName: "Blood Pressure (Diastolic)",
                    unit: "mmHg",
                    value: diastolic,
                    confidence: "extracted"
                )
            ]
        }
        return []
    }

    private static func firstNumericValue(forAliases aliases: [String], in lowercasedText: String, originalText: String) -> Double? {
        for alias in aliases {
            guard let aliasRange = lowercasedText.range(of: alias) else { continue }
            let searchStart = aliasRange.upperBound
            let searchEnd = lowercasedText.index(searchStart, offsetBy: 40, limitedBy: lowercasedText.endIndex) ?? lowercasedText.endIndex
            let window = String(lowercasedText[searchStart..<searchEnd])

            guard let regex = try? NSRegularExpression(pattern: "-?\\d+(\\.\\d+)?") else { continue }
            let nsWindow = window as NSString
            guard let match = regex.firstMatch(in: window, range: NSRange(location: 0, length: nsWindow.length)) else { continue }
            let numberString = nsWindow.substring(with: match.range)
            if let value = Double(numberString) {
                return value
            }
        }
        return nil
    }
}
