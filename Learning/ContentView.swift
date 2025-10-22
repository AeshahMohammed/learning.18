//
//  ContentView.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 20/10/2025.
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

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var learnedDays = 5
    @State private var frozenDays = 1
    @State private var showMonthPicker = false
    @State private var loggedDays: [LoggedDay] = []
    var freezeLimit=2

    var currentWeekDates: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: selectedDate) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    func changeWeek(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }

    var monthYearFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f
    }

    var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }

    var shortWeekdayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "E"
        return f
    }

    
    let days = [
        ("SUN", 20), ("MON", 21), ("TUE", 22),
        ("WED", 23), ("THU", 24), ("FRI", 25), ("SAT", 26)
    ]
    
    func isLogged(_ date: Date, as status: DayStatus) -> Bool {
        loggedDays.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) && $0.status == status })
    }

    func logDay(as status: DayStatus) {
        // prevent duplicate logging
        guard !loggedDays.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) else { return }
        
        if status == .frozen {
            // respect freeze limit
            guard frozenDays < freezeLimit else { return }
            frozenDays += 1
        } else {
            learnedDays += 1
        }
        
        loggedDays.append(LoggedDay(date: selectedDate, status: status))
    }

    func colorFor(date: Date) -> Color {
        let calendar = Calendar.current
        
        if isLogged(date, as: .learned) {
            // current = dark orange, previous = light orange
            return calendar.isDate(date, inSameDayAs: selectedDate) ? Color.orange : Color.orange.opacity(0.5)
        }
        if isLogged(date, as: .frozen) {
            // light blue for frozen
            return Color.blue.opacity(0.6)
        }
        return Color.black.opacity(0.3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
            // Top header
                // Top header with icons
                HStack {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "calendar")}
                        Button(action: {}) {
                            Image(systemName: "person.circle")}
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                }
                .padding(.top, 20)

            
         
              
           
                    // MARK: - Calendar Section
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Month header
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showMonthPicker.toggle() // 👈 toggles compact date picker
                                }
                            }) {
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
                                Button(action: { changeWeek(by: -1) }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.orange)
                                }
                                Button(action: { changeWeek(by: 1) }) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        
                        if showMonthPicker {
                            DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .transition(.opacity)
                            .onChange(of: selectedDate) { _ in
                                withAnimation { showMonthPicker = false }
                            }
                        }
                        
                        // Days of the current week
                        HStack(spacing: 12) {
                            ForEach(currentWeekDates, id: \.self) { date in
                                let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                
                                Button {
                                    withAnimation {
                                        selectedDate = date
                                    }
                                } label: {
                                    VStack {
                                        Text(shortWeekdayFormatter.string(from: date).uppercased())
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        Text(dayFormatter.string(from: date))
                                            .font(.headline)
                                            .padding(10)
                                            .background(
                                                Circle().fill(isSelected ? Color.orange : Color.black.opacity(0.3))
                                            )
                                            .foregroundColor(.white)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    
                    Text("Learning Swift")
                        .font(.headline)
                        .foregroundColor(.white)
                    Divider().background(Color.white.opacity(0.1))

                    HStack(spacing: 28) {
                        HStack(spacing: 30) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(learnedDays)")
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Days Learned")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 9)
                        .padding(.horizontal, 16)
                        .background(Color(red: 0.25, green: 0.17, blue: 0.11)) // brownish tone
                        .cornerRadius(30)
                        .glassEffect()
                        
                        HStack(spacing: 30) {
                            Image(systemName: "cube.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(frozenDays)")
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Day Freezed")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.vertical, 9)
                        .padding(.horizontal, 16)
                        .background(Color(red: 0.13, green: 0.20, blue: 0.25)) // bluish tone
                        .cornerRadius(30)
                        .glassEffect()
                    }
                    Spacer().padding()
                    
                      
                }  .padding(10)
                    .background(Color(red: 0.10, green: 0.10, blue: 0.10))
                    .cornerRadius(16)

                
                // Big button
                VStack(spacing: 16) {Button {
                    logDay(as: .learned)
                } label: {
                    Text(isLogged(selectedDate, as: .learned) ? "Learned Today" : "Log as Learned")
                            .font(.largeTitle)
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 250)
                            .background(Color.orange.opacity(0.8))
                            .glassEffect()
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    Spacer().padding(16)

                    
                    
                    Button {logDay(as: .frozen)} label: {
                        Text(isLogged(selectedDate, as: .frozen) ? "Day Frozen" : "Log as Freezed")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .glassEffect()
                    }
                    
                    Text("1 out of 2 Freezes used")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
        .padding()
                        .background(Color.black.ignoresSafeArea())
         
        }
     
}
#Preview {
    ContentView()
}
