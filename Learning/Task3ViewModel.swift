//
//  Task3ViewModel.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI
import Combine

final class Task3ViewModel: ObservableObject {
    // UI state moved from view
    @Published var goToTask5: Bool = false
    @Published var showMonthPicker: Bool = false
    @Published var goToTask4: Bool = false

    func totalDaysRequired(for goalDuration: String) -> Int {
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
}
