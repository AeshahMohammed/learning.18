//
//  Task4ViewModel.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//



import SwiftUI
import Combine

final class Task4ViewModel: ObservableObject {
    @Published var goToTask2: Bool = false
    @Published var goalText: String = ""
    @Published var selectedDuration: String = "Month"
    @Published var showConfirmation: Bool = false
}
