//
//  Task3View.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//




import SwiftUI

struct Task3View: View {
    // Reuse data from Task2 (bindings remain)
    @Binding var goalSubject: String
    @Binding var goalDuration: String
    @Binding var selectedDate: Date
    @Binding var learnedDays: Int
    @Binding var frozenDays: Int
    @Binding var loggedDays: [LoggedDay]

    // formatters / helpers that were passed in originally
    let monthYearFormatter: DateFormatter
    let shortWeekdayFormatter: DateFormatter
    let dayFormatter: DateFormatter
    let colorFor: (Date) -> Color
    var currentWeekDates: [Date]

    // moved state into view model
    @StateObject private var viewModel = Task3ViewModel()
    @Environment(\.dismiss) var dismiss

    var showCelebration: Bool {
        learnedDays + frozenDays >= viewModel.totalDaysRequired(for: goalDuration)
    }

    var body: some View {
        NavigationStack {
            VStack {
                // HEADER
                HStack {
                    Text("Activity")
                        .padding(16)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: { viewModel.goToTask5 = true }) {
                            Image(systemName: "calendar")
                        }
                        Button(action: {}) { Image(systemName: "person.circle") }
                    }
                    .padding(10)
                    .font(.title3)
                    .foregroundColor(.primary)
                }
                .padding(.top, 20)

                // CARD SECTION (same as Task2)
                VStack(alignment: .leading, spacing: 16) {
                    // Month & Week Navigation
                    HStack {
                        Button(action: { withAnimation { viewModel.showMonthPicker.toggle() } }) {
                            HStack(spacing: 4) {
                                Text(selectedDate, formatter: monthYearFormatter)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.orange)
                                    .rotationEffect(.degrees(viewModel.showMonthPicker ? 180 : 0))
                            }
                        }
                        Spacer()
                    }

                    if viewModel.showMonthPicker {
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .transition(.opacity)
                            .onChange(of: selectedDate) { _ in
                                withAnimation { viewModel.showMonthPicker = false }
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
                                        .foregroundColor(.secondary)
                                    Text(dayNumber)
                                        .font(.title.bold())
                                        .foregroundColor(.primary)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(color))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Learning Swift Section
                    Text("Learning \(goalSubject)")
                        .font(.headline)
                        .foregroundColor(.primary)
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
                                    .foregroundColor(.primary)
                            }
                        }   .frame(width: 150, height: 60)

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
                                    .foregroundColor(.primary)
                            }
                        }    .frame(width: 150, height: 60)

                            .padding(.vertical, 9)
                            .padding(.horizontal, 16)
                            .background(Color(red: 0.13, green: 0.20, blue: 0.25))
                            .cornerRadius(30)
                            .glassEffect()
                    }
                }
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(16)

                // 🎉 GOAL COMPLETED SECTION
                if showCelebration {
                    VStack(spacing:24) {
                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                            .symbolEffect(.wiggle)

                        Text("Well done!")
                            .font(.title3.bold())
                            .foregroundColor(.primary)

                        Text("Goal completed!\n You can start learning again or set new learning goal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: Task4(), isActive: $viewModel.goToTask4) {
                            EmptyView()
                        }
                        NavigationLink(destination:
                                        Task5(
                                            loggedDays: $loggedDays,
                                            selectedDate: $selectedDate
                                        ),
                                       isActive: $viewModel.goToTask5
                        ) {
                            EmptyView()
                        }

                        Button {
                            viewModel.goToTask4 = true
                        } label: {
                            Text("Set new learning goal")
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.primary)
                                .cornerRadius(25)
                                .glassEffect()
                        }

                        Button {
                            dismiss()
                            // Keep same goal logic
                        } label: {
                            Text("Set same learning goal and duration")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .padding(100)
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct Task3View_Previews: PreviewProvider {
    static var previews: some View {
        Task3View(
            goalSubject: .constant("Swift"),
            goalDuration: .constant("2 weeks"),
            selectedDate: .constant(Date()),
            learnedDays: .constant(3),
            frozenDays: .constant(1),
            loggedDays: .constant([]),
            monthYearFormatter: {
                let f = DateFormatter()
                f.dateFormat = "MMMM yyyy"
                return f
            }(),
            shortWeekdayFormatter: {
                let f = DateFormatter()
                f.dateFormat = "EEE"
                return f
            }(),
            dayFormatter: {
                let f = DateFormatter()
                f.dateFormat = "d"
                return f
            }(),
            colorFor: { _ in .orange },
            currentWeekDates: {
                let calendar = Calendar.current
                let today = Date()
                let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: today)!.start
                return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
            }()
        )
    }
}
