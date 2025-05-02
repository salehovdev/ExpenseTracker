//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 02.05.25.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            SummaryView(expense: Expenses(amount: 1, category: "Food", date: .now, note: ""))
        }
        .modelContainer(for: Expenses.self)
    }
}
