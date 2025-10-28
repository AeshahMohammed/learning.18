//
//  LoggedDay.swift
//  Learning
//
//  Created by aeshah mohammed alabdulkarim on 28/10/2025.
//




import Foundation

struct LoggedDay: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    var status: DayStatus
}
