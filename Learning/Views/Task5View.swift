//
//  Task5View.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI

struct Task5: View {
    @Binding var loggedDays: [LoggedDay]
    @Binding var selectedDate: Date

    @StateObject private var viewModel: Task5ViewModel

    init(loggedDays: Binding<[LoggedDay]>, selectedDate: Binding<Date>) {
        self._loggedDays = loggedDays
        self._selectedDate = selectedDate
        self._viewModel = StateObject(wrappedValue: Task5ViewModel(loggedDays: loggedDays, selectedDate: selectedDate))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(viewModel.months, id: \.self) { month in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(month, format: .dateTime.month(.wide).year())
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        let days = viewModel.generateDays(for: month)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                            ForEach(days, id: \.self) { date in
                                if let date = date {
                                    Text("\(viewModel.calendar.component(.day, from: date))")
                                        .font(.subheadline.bold())
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(viewModel.colorFor(date: date)))
                                        .foregroundColor(viewModel.colorFor(date: date) == .clear ? .secondary : .white)
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
}

struct Task5_Previews: PreviewProvider {
    static var previews: some View {
        Task5(
            loggedDays: .constant([
                LoggedDay(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, status: .learned),
                LoggedDay(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, status: .frozen),
                LoggedDay(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, status: .learned)
            ]),
            selectedDate: .constant(Date())
        )
    }
}
