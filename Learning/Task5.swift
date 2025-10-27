//
//  Task5View.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 27/10/2025.
//

import SwiftUI

struct Task5: View {
    @Binding var loggedDays: [LoggedDay]
    @Binding var selectedDate: Date

    let calendar = Calendar.current
    
    // Generate months for display
    var months: [Date] {
        guard let start = calendar.date(byAdding: .month, value: -12, to: Date()) else { return [] }
        return (0..<13).compactMap { calendar.date(byAdding: .month, value: $0, to: start) }
    }
    
    // ✅ Fixed function: check log.status instead of log.isFrozen
    func colorFor(date: Date) -> Color {
        if let log = loggedDays.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return log.status == .frozen ? .blue : .orange
        } else {
            return Color.clear
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(months, id: \.self) { month in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(month, format: .dateTime.month(.wide).year())
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        let days = generateDays(for: month)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                            ForEach(days, id: \.self) { date in
                                if let date = date {
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.subheadline.bold())
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(colorFor(date: date)))
                                        .foregroundColor(colorFor(date: date) == .clear ? .secondary : .white)
                                } else {
                                    Text("")
                                        .frame(width: 36, height: 36)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 20)
        }
        .navigationTitle("All activities")
        .background(Color(.systemBackground).ignoresSafeArea())
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
#Preview {
    Task5(
        loggedDays: .constant([
            LoggedDay(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, status: .learned),
            LoggedDay(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, status: .frozen),
            LoggedDay(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, status: .learned)
        ]),
        selectedDate: .constant(Date())
    )
}
