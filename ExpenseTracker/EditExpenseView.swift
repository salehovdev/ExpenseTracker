//
//  EditExpenseView.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 09.05.25.
//

import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var expense: Expenses
    
    @State private var amount: Int
    @State private var categorySelection: String
    @State private var date: Date
    @State private var noteText: String
    
    let categoryOptions: [String] = [
        "Food", "Transportation", "Shopping", "Other"
    ]
    
    init(expense: Expenses) {
        self.expense = expense
        _amount = State(initialValue: expense.amount)
        _categorySelection = State(initialValue: expense.category)
        _date = State(initialValue: expense.date)
        _noteText = State(initialValue: expense.note)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("0", value: $amount, format: .number)
                }
                
                Section("Category") {
                    Picker("Category", selection: $categorySelection) {
                        ForEach(categoryOptions, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                
                Section("Date") {
                    DatePicker("Select a date", selection: $date, displayedComponents: [.date])
                }
                
                Section("Note") {
                    TextEditor(text: $noteText)
                        .frame(height: 150)
                }
            }
            
            Button {
                
                expense.amount = amount
                expense.category = categorySelection
                expense.date = date
                expense.note = noteText
                
                dismiss()
            } label: {
                Text("Update".uppercased())
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal, 150)
                    .background(
                        Color.blue
                            .clipShape(.capsule)
                            .shadow(radius: 10)
                    )
            }
            .navigationTitle("Edit Expense")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditExpenseView(expense: .init(amount: 1, category: "Food", date: .now, note: ""))
}
