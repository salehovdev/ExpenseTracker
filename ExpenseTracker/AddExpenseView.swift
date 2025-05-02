//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 02.05.25.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var amount: Int = 0
    @State private var categorySelection: String = "Food"
    @State private var date: Date = .now
    @State private var noteText: String = ""
    
    let categoryOptions: [String] = [
        "Food", "Transportation", "Shopping", "Other"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("0", value: $amount, format: .number)
                }
                    
                Section("Category") {
                    Picker("\(categorySelection)", selection: $categorySelection) {
                        ForEach(categoryOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                    
                Section("Date") {
                    DatePicker("Select a date", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.automatic)
                }
                    
                Section("Note") {
                    TextEditor(text: $noteText)
                        .frame(height: 150)
                }
            }
            
            Button {
                //New expense
                let newExpense = Expenses(amount: amount, category: categorySelection, date: date, note: noteText)
                modelContext.insert(newExpense)
                
                
                dismiss()
            } label: {
                Text("Save".uppercased())
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
                .navigationTitle("Add Expense")
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
    AddExpenseView()
}
