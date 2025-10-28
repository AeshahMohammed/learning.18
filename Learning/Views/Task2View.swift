//
//  Task2View.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI

struct Task2View: View {
    @Binding var goalSubject: String
    @Binding var goalDuration: String

    // initialize StateObject with the bindings so the VM reads the latest goal values
    @StateObject private var viewModel: Task2ViewModel

    // custom init so we can create the StateObject with bindings
    init(goalSubject: Binding<String>, goalDuration: Binding<String>) {
        self._goalSubject = goalSubject
        self._goalDuration = goalDuration
        self._viewModel = StateObject(wrappedValue: Task2ViewModel(goalSubject: goalSubject, goalDuration: goalDuration))
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    NavigationLink(destination:
                                    Task5(loggedDays: $viewModel.loggedDays,
                                          selectedDate: $viewModel.selectedDate),
                                   isActive: $viewModel.goToTask5) { EmptyView() }

                    Text("Activity")
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
                    .font(.title3)
                    .foregroundColor(.primary)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    // Month + Week
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Button(action: { withAnimation { viewModel.showMonthPicker.toggle() } }) {
                                HStack(spacing: 4) {
                                    Text(viewModel.selectedDate, formatter: viewModel.monthYearFormatter)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.orange)
                                        .rotationEffect(.degrees(viewModel.showMonthPicker ? 180 : 0))
                                }
                            }
                            Spacer()
                            HStack(spacing: 16) {
                                Button(action: { viewModel.changeWeek(by: -1) }) { Image(systemName: "chevron.left").foregroundColor(.orange) }
                                Button(action: { viewModel.changeWeek(by: 1) }) { Image(systemName: "chevron.right").foregroundColor(.orange) }
                            }
                        }

                        if viewModel.showMonthPicker {
                            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.date])
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .colorScheme(.dark)
                                .transition(.opacity)
                                .onChange(of: viewModel.selectedDate) { _ in
                                    withAnimation { viewModel.showMonthPicker = false }
                                }
                        }

                        // Weekdays row
                        VStack(alignment: .leading, spacing: 14) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.currentWeekDates, id: \.self) { date in
                                        let weekday = viewModel.shortWeekdayFormatter.string(from: date)
                                        let dayNumber = viewModel.dayFormatter.string(from: date)

                                        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                                        let learned = viewModel.isLogged(date, as: .learned)
                                        let frozen = viewModel.isLogged(date, as: .frozen)

                                        // base colors for non-selected states
                                        let baseColor: Color = {
                                            if learned { return Color.orange.opacity(0.5) }
                                            if frozen  { return Color.blue.opacity(0.6) }
                                            return Color.black.opacity(0.3)
                                        }()

                                        // final fill color (darker if selected)
                                        let fillColor: Color = {
                                            if isSelected {
                                                if frozen { return Color.blue.opacity(0.85) }      // selected frozen -> darker blue
                                                return Color.orange.opacity(0.9)                  // selected learned/empty -> darker orange
                                            } else {
                                                return baseColor
                                            }
                                        }()

                                        VStack(spacing: 5) {
                                            Text(weekday)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)

                                            Text(dayNumber)
                                                .font(.title.bold())
                                                .foregroundColor(.primary)
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .fill(fillColor)
                                                        .overlay(
                                                            // selected ring
                                                            Circle()
                                                                .stroke(isSelected ? (frozen ? Color.blue : Color.orange) : Color.clear, lineWidth: isSelected ? 4 : 0)
                                                        )
                                                        .animation(.easeInOut(duration: 0.18), value: isSelected)
                                                ).padding(4)
                                        }
                                        .onTapGesture {
                                            withAnimation { viewModel.selectedDate = date }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical,6)
                            }
                        }

                    }

                    Text("Learning \(goalSubject)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Divider().background(Color.white.opacity(0.1))

                    // Stats cards
                    HStack(spacing: 28) {
                        HStack(spacing: 30) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(viewModel.learnedDays)").bold().foregroundColor(.white)
                                Text(viewModel.learnedDays == 1 ? "Day Learned" : "Days Learned")
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
                                Text("\(viewModel.frozenDays)").bold().foregroundColor(.white)
                                Text(viewModel.frozenDays == 1 ? "Day Freezed" : "Days Freezed")
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
                    Spacer().padding()
                }
                .padding(10)
                .background(Color(.systemBackground))
                .cornerRadius(16)

                // Big circle + buttons
                VStack(spacing: 16) {
                    let selectedIsLearned = viewModel.isLogged(viewModel.selectedDate, as: .learned)
                    let selectedIsFrozen = viewModel.isLogged(viewModel.selectedDate, as: .frozen)

                    ZStack {
                        Circle()
                            .fill(selectedIsFrozen ? Color.learnedBlue2 : (selectedIsLearned ? Color.orange.opacity(0.9)  : Color.orange.opacity(0.7)))
                          //  .glassEffect()
                            .overlay(
                                Circle().stroke(
                                    selectedIsFrozen ? Color.learnedBlue : (selectedIsLearned ? Color.learnedOrange : Color.clear),
                                    lineWidth: 10
                                )
                            )
                            .frame(width: 250, height: 250)
                            .glassEffect()

                        Text(selectedIsFrozen ? "Day Frozen" :
                                selectedIsLearned ? "Learned Today" :
                                "Log as Learned")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    }
                    .onTapGesture {
                        if !selectedIsLearned && !selectedIsFrozen {
                            viewModel.logDay(as: .learned)
                        }
                    }

                    Button {
                        viewModel.logDay(as: .frozen)
                    } label: {
                        Text(viewModel.isLogged(viewModel.selectedDate, as: .frozen) ? "Day Frozen" : "Log as Freezed")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isLogged(viewModel.selectedDate, as: .frozen) ? Color.black.opacity(0.7) : Color.blue.opacity(0.8))
                            .foregroundColor(.primary)
                            .cornerRadius(25)
                            .glassEffect()
                    }
                    .disabled(viewModel.isLogged(viewModel.selectedDate, as: .learned) || viewModel.isLogged(viewModel.selectedDate, as: .frozen) || viewModel.frozenDays >= viewModel.freezeLimit)

                    Text("\(viewModel.frozenDays) out of \(viewModel.freezeLimit) \(viewModel.freezeLimit == 1 ? "Freeze" : "Freezes") used")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemBackground).ignoresSafeArea())
            .onAppear { viewModel.checkForStreakReset() }

            NavigationLink(
                "",
                destination: Task3View(
                    goalSubject: $goalSubject,
                    goalDuration: $goalDuration,
                    selectedDate: $viewModel.selectedDate,
                    learnedDays: $viewModel.learnedDays,
                    frozenDays: $viewModel.frozenDays,
                    loggedDays: $viewModel.loggedDays,
                    monthYearFormatter: viewModel.monthYearFormatter,
                    shortWeekdayFormatter: viewModel.shortWeekdayFormatter,
                    dayFormatter: viewModel.dayFormatter,
                    colorFor: viewModel.colorFor(date:),
                    currentWeekDates: viewModel.currentWeekDates
                ),
                isActive: $viewModel.weekCompleted
            ).opacity(0)
        }
    }
}

struct Task2View_Previews: PreviewProvider {
    static var previews: some View {
        Task2View(
            goalSubject: .constant("Swift"),
            goalDuration: .constant("2 weeks")
        )
    }
}
