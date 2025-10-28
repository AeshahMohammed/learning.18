//
//  Task1ViewModel.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI
import Combine   // Required for ObservableObject / @Published

class Task1ViewModel: ObservableObject {
    @Published var selectedDuration: String
    @Published var subject: String

    init(selectedDuration: String = "Week", subject: String = "Swift") {
        self.selectedDuration = selectedDuration
        self.subject = subject
    }
}

