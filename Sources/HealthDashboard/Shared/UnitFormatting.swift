import Foundation

enum UnitFormatting {
    static func liters(fromMilliliters milliliters: Int) -> String {
        String(format: "%.2f L", Double(milliliters) / 1000.0)
    }

    static func calories(_ value: Int) -> String {
        "\(value) kcal"
    }

    static func units(_ value: Double) -> String {
        String(format: "%.1f units", value)
    }

    static func percent(_ value: Double) -> String {
        String(format: "%.0f%%", value.isFinite ? min(max(value, 0), 100) : 0)
    }

    static func oneDecimal(_ value: Double) -> String {
        String(format: "%.1f", value)
    }
}
