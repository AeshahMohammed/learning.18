//
//  Task2.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 23/10/2025.
//

import SwiftUI

struct LoggedDay: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    var status: DayStatus
}

enum DayStatus {
    case learned
    case frozen
}

struct Task2View: View {
    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var learnedDays = 0
    @State private var frozenDays = 0
    @State private var showMonthPicker = false
    @State private var loggedDays: [LoggedDay] = []
    @State private var lastLogDate: Date? = nil
    @State private var learningGoalUpdated = false
    @State private var weekCompleted = false

    let freezeLimit = 2

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
        if learnedDays + frozenDays >= 7 {
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

    var body: some View {
        NavigationStack {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Text("Activity")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 16) {
                    Button(action: {}) { Image(systemName: "calendar") }
                    Button(action: {}) { Image(systemName: "person.circle") }
                }
                .font(.title3)
                .foregroundColor(.white)
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                // Month + Week
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button(action: { withAnimation { showMonthPicker.toggle() } }) {
                            HStack(spacing: 4) {
                                Text(selectedDate, formatter: monthYearFormatter)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.orange)
                                    .rotationEffect(.degrees(showMonthPicker ? 180 : 0))
                            }
                        }
                        Spacer()
                        HStack(spacing: 16) {
                            Button(action: { changeWeek(by: -1) }) { Image(systemName: "chevron.left").foregroundColor(.orange) }
                            Button(action: { changeWeek(by: 1) }) { Image(systemName: "chevron.right").foregroundColor(.orange) }
                        }
                    }
                    
                    if showMonthPicker {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .transition(.opacity)
                            .onChange(of: selectedDate) { _ in
                                withAnimation { showMonthPicker = false }
                            }
                    }
                    
                    // Weekdays row// Weekdays row
                    VStack(alignment: .leading, spacing: 14) {
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(currentWeekDates, id: \.self) { date in
                                    let weekday = shortWeekdayFormatter.string(from: date)
                                    let dayNumber = dayFormatter.string(from: date)
                                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                    let color = colorFor(date: date)
                                    
                                    VStack(spacing: 5) {
                                        Text(weekday)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        
                                        Text(dayNumber)
                                            .font(.title.bold())
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(
                                                Circle()
                                                    .fill(color)
                                            )
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDate = date
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                }
                
                Text("Learning Swift")
                    .font(.headline)
                    .foregroundColor(.white)
                Divider().background(Color.white.opacity(0.1))
                
                // Stats cards
                HStack(spacing: 28) {
                    HStack(spacing: 30) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(learnedDays)").bold().foregroundColor(.white)
                            Text(learnedDays == 1 ? "Day Learned" : "Days Learned")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 16)
                    .background(Color(red: 0.25, green: 0.17, blue: 0.11))
                    .cornerRadius(30)
                    .glassEffect() // your original
                    
                    HStack(spacing: 30) {
                        Image(systemName: "cube.fill")
                            .foregroundColor(.blue)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(frozenDays)").bold().foregroundColor(.white)
                            Text(frozenDays == 1 ? "Day Freezed" : "Days Freezed")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 16)
                    .background(Color(red: 0.13, green: 0.20, blue: 0.25))
                    .cornerRadius(30)
                    .glassEffect() // your original
                }
                Spacer().padding()
            }
            .padding(10)
            .background(Color(red: 0.10, green: 0.10, blue: 0.10))
            .cornerRadius(16)
            
            // Big circle + buttons
            VStack(spacing: 16) {
                let selectedIsLearned = isLogged(selectedDate, as: .learned)
                let selectedIsFrozen = isLogged(selectedDate, as: .frozen)
                
                ZStack {
                    Circle()
                        .fill(selectedIsFrozen ? Color.black : (selectedIsLearned ? Color.orange.opacity(0.9)  : Color.orange.opacity(0.7)))
                        .glassEffect()
                        .overlay(
                            Circle().stroke(
                                selectedIsFrozen ? Color.blue : (selectedIsLearned ? Color.orange : Color.clear),
                                lineWidth: 10
                            )
                        )
                        .frame(width: 250, height: 250)
                        .glassEffect() // your original
                    
                    Text(selectedIsFrozen ? "Day Frozen" :
                            selectedIsLearned ? "Learned Today" :
                            "Log as Learned")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                }
                .onTapGesture {
                    if !selectedIsLearned && !selectedIsFrozen {
                        logDay(as: .learned)
                    }
                }
                
                Button {
                    logDay(as: .frozen)
                } label: {
                    Text(selectedIsFrozen ? "Day Frozen" : "Log as Freezed")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedIsFrozen ? Color.black.opacity(0.7) : Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .glassEffect() // your original
                }
                .disabled(selectedIsLearned || selectedIsFrozen || frozenDays >= freezeLimit)
                
                Text("\(frozenDays) out of \(freezeLimit) \(freezeLimit == 1 ? "Freeze" : "Freezes") used")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onAppear { checkForStreakReset() }
        NavigationLink("", destination: Task3View(
        selectedDate: $selectedDate,
        learnedDays: $learnedDays,
        frozenDays: $frozenDays,
        loggedDays: $loggedDays,
        monthYearFormatter: monthYearFormatter,
        shortWeekdayFormatter: shortWeekdayFormatter,
        dayFormatter: dayFormatter,
        colorFor: colorFor(date:),
        currentWeekDates: currentWeekDates),
    isActive: $weekCompleted).opacity(0) }
    }
}

#Preview {
    Task2View()
}



