//
//  Task5ViewModel.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//


import SwiftUI
import Combine

final class Task5ViewModel: ObservableObject {
    private let loggedDaysBinding: Binding<[LoggedDay]>
    private let selectedDateBinding: Binding<Date>
    let calendar = Calendar.current

    var months: [Date] {
        guard let start = calendar.date(byAdding: .month, value: -12, to: Date()) else { return [] }
        return (0..<13).compactMap { calendar.date(byAdding: .month, value: $0, to: start) }
    }

    init(loggedDays: Binding<[LoggedDay]>, selectedDate: Binding<Date>) {
        self.loggedDaysBinding = loggedDays
        self.selectedDateBinding = selectedDate
    }

    func colorFor(date: Date) -> Color {
        if let log = loggedDaysBinding.wrappedValue.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return log.status == .frozen ? .blue : .orange
        } else {
            return Color.clear
        }
    }

    func generateDays(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstDay)
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        for day in range {
            days.append(calendar.date(byAdding: .day, value: day - 1, to: firstDay))
        }
        return days
    }
}

