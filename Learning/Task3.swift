//
//  Task3.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 23/10/2025.
//


//  ContentView.swift
//  Learning
import SwiftUI

struct Task3View: View {
    // Reuse data from Task2
    @Binding var selectedDate: Date
    @Binding var learnedDays: Int
    @Binding var frozenDays: Int
    @Binding var loggedDays: [LoggedDay]
    
    // same formatters
    let monthYearFormatter: DateFormatter
    let shortWeekdayFormatter: DateFormatter
    let dayFormatter: DateFormatter
    let colorFor: (Date) -> Color
    var currentWeekDates: [Date]
    
    @State private var showMonthPicker = false
    
    var body: some View {
        VStack {
            // HEADER
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
            
            // CARD SECTION (same as Task2)
            VStack(alignment: .leading, spacing: 16) {
                // Month & Week Navigation
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
                
                // Weekdays Row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(currentWeekDates, id: \.self) { date in
                            let weekday = shortWeekdayFormatter.string(from: date)
                            let dayNumber = dayFormatter.string(from: date)
                            let color = colorFor(date)
                            
                            VStack(spacing: 5) {
                                Text(weekday)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text(dayNumber)
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Circle().fill(color))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Learning Swift Section
                Text("Learning Swift")
                    .font(.headline)
                    .foregroundColor(.white)
                Divider().background(Color.white.opacity(0.1))
                
                // Stats Cards
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
                    .glassEffect()
                    
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
                    .glassEffect()
                }
            }            //here mshmsh
            .padding(10)
            .background(Color(red: 0.10, green: 0.10, blue: 0.10))
            .cornerRadius(16)
            
            // 🎉 GOAL COMPLETED SECTION
            VStack(spacing:24) {
                Image(systemName: "hands.clap.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .symbolEffect(.wiggle)
                
                Text("Well done!")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Text("                             Goal completed!\n       You can start learning again or set new                         \n                                learning goal")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Button {
                    // Reset goal logic (return to Task2View)
                } label: {
                    Text("Set new learning goal")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .glassEffect()
                }
                
                Button {
                    // Keep same goal logic
                } label: {
                    Text("Set same learning goal and duration")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date()
    let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: today)!.start
    let weekDates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    
    return Task3View(
        selectedDate: .constant(Date()),
        learnedDays: .constant(7),
        frozenDays: .constant(1),
        loggedDays: .constant([]),
        monthYearFormatter: {
            let f = DateFormatter()
            f.dateFormat = "LLLL yyyy"
            return f
        }(),
        shortWeekdayFormatter: {
            let f = DateFormatter()
            f.dateFormat = "E"
            return f
        }(),
        dayFormatter: {
            let f = DateFormatter()
            f.dateFormat = "d"
            return f
        }(),
        colorFor: { _ in Color.orange },
        currentWeekDates: weekDates
    )
}

