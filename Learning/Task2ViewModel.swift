//
//  Task2ViewModel.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI
import Combine

final class Task2ViewModel: ObservableObject {
    // Keep bindings to the parent goal values so we always read the latest
    private let goalSubjectBinding: Binding<String>
    private let goalDurationBinding: Binding<String>

    // Exposed read-only (via binding) accessors for code that used goalSubject/goalDuration
    var goalSubject: String { goalSubjectBinding.wrappedValue }
    var goalDuration: String { goalDurationBinding.wrappedValue }

    // UI state moved from the view
    @Published var goToTask5: Bool = false
    @Published var selectedDate: Date = Date()
    @Published var learnedDays: Int = 0
    @Published var frozenDays: Int = 0
    @Published var showMonthPicker: Bool = false
    @Published var loggedDays: [LoggedDay] = []
    @Published var lastLogDate: Date? = nil
    @Published var learningGoalUpdated: Bool = true
    @Published var weekCompleted: Bool = false

    let freezeLimit = 2

    init(goalSubject: Binding<String>, goalDuration: Binding<String>) {
        self.goalSubjectBinding = goalSubject
        self.goalDurationBinding = goalDuration
    }

    // Ensure all comparisons are normalized
    func startOfDay(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    var currentWeekDates: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: selectedDate) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfDay(weekInterval.start)) }
    }

    func changeWeek(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: value, to: selectedDate) {
            selectedDate = startOfDay(newDate)
        }
    }

    var monthYearFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f
    }

    var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.calendar = Calendar.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "d"
        return f
    }

    var shortWeekdayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "E"
        return f
    }

    func isLogged(_ date: Date, as status: DayStatus) -> Bool {
        loggedDays.contains(where: { startOfDay($0.date) == startOfDay(date) && $0.status == status })
    }

    func isAnyLogged(_ date: Date) -> Bool {
        loggedDays.contains(where: { startOfDay($0.date) == startOfDay(date) })
    }

    func totalDaysRequired() -> Int {
        switch goalDuration.lowercased() {
        case "week", "1 week", "weekly":
            return 7
        case "month", "1 month", "monthly":
            return 30
        case "year", "1 year", "yearly":
            return 365
        default:
            return 7
        }
    }

    func logDay(as status: DayStatus) {
        guard !isAnyLogged(selectedDate) else { return }
        if status == .frozen {
            guard frozenDays < freezeLimit else { return }
            frozenDays += 1
        } else {
            learnedDays += 1
        }
        loggedDays.append(LoggedDay(date: selectedDate, status: status))
        lastLogDate = Date()
        if learnedDays + frozenDays >= totalDaysRequired() {
            weekCompleted = true
        }
    }

    func colorFor(date: Date) -> Color {
        if isLogged(date, as: .learned) {
            return Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.orange : Color.orange.opacity(0.5)
        }
        if isLogged(date, as: .frozen) {
            return Color.blue.opacity(0.6)
        }
        return Color.black.opacity(0.3)
    }

    func checkForStreakReset() {
        if learningGoalUpdated {
            learnedDays = 0
            frozenDays = 0
            loggedDays.removeAll()
            learningGoalUpdated = false
            return
        }
        guard let last = lastLogDate else { return }
        let hoursSinceLast = Date().timeIntervalSince(last) / 3600
        if hoursSinceLast > 32 {
            learnedDays = 0
            frozenDays = 0
            loggedDays.removeAll()
        }
    }
}

