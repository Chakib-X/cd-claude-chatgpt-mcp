import Foundation

enum DateUtilities {
    static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }

    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func startOfWeek(containing date: Date) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? startOfDay(date)
    }

    static func endOfDay(_ date: Date) -> Date {
        calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay(date)) ?? date
    }

    static func daysAgo(_ count: Int, from date: Date = Date()) -> Date {
        calendar.date(byAdding: .day, value: -count, to: startOfDay(date)) ?? date
    }
}
