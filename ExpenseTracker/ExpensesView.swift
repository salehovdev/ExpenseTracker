//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 02.05.25.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var expenses: [Expenses]

    var body: some View {
        NavigationStack {
            let groupedExpenses = Dictionary(grouping: expenses) { formattedDate($0.date) }

            List {
                ForEach(groupedExpenses.sorted(by: { $0.key > $1.key }), id: \.key) { date, expensesForDate in
                    Section(header: Text(date)) {
                        ForEach(expensesForDate) { expense in
                            NavigationLink(destination: EditExpenseView(expense: expense)) {
                                HStack {
                                    IconView(category: expense.category)
                                    
                                    VStack(alignment: .leading) {
                                        Text(expense.note)
                                            .font(.headline)
                                        Text(expense.category)
                                            .font(.subheadline)
                                    }
                                    .padding(.horizontal, 10)
                                    
                                    Spacer()
                                    
                                    Text("€\(expense.amount)")
                                }
                            }
                        }
                        .onDelete { offsets in
                            deleteExpenses(expensesForDate, at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    //Delete func
    func deleteExpenses(_ expensesForDate: [Expenses], at offsets: IndexSet) {
        for offset in offsets {
            let expense = expensesForDate[offset]
            modelContext.delete(expense)
        }
    }

    //Date format
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let example = Expenses(amount: 10, category: "Food", date: .now, note: "Groceries")
        
        return ExpensesView()
            .modelContainer(container)
    } catch {
        return Text("Failed")
    }
}




