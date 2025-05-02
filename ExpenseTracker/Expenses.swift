//
//  Expenses.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 03.05.25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Expenses: Identifiable {
    var id = UUID()
    var amount: Int
    var category: String
    var date: Date
    var note: String

    init(amount: Int, category: String, date: Date, note: String) {
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
}
