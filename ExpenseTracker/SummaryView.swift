//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 02.05.25.
//

import SwiftUI
import SwiftData
import Charts

struct SummaryView: View {
    
    //MARK: Variables
    @Environment(\.modelContext) var modelContext
    
    @Query var expenses: [Expenses]
    
    @AppStorage("totalExpenses") var totalExpenses: Double = 0.0
    
    @State private var showingAddScreen = false
    @State private var showExpenseView = false
    @State private var isAnimated = false
    
    let expense: Expenses
    
    var body: some View {
        
        var totalAmount: Double {
            expenses.reduce(0) { $0 + Double($1.amount) }
        }
        
        var categoryTotals: [String: Double] {
                Dictionary(grouping: expenses, by: { $0.category })
                .mapValues { Double($0.reduce(0) { $0 + $1.amount }) }
            }
        
        //MARK: Summary View
        NavigationStack {
            VStack {
                    Button {
                        showExpenseView.toggle()
                    } label: {
                        Chart {
                            ForEach(categoryTotals.sorted(by: { $0.key < $1.key }), id: \.key) { category, total in
                                SectorMark(
                                    angle: .value("Amount", isAnimated ? total : 0),
                                    innerRadius: .ratio(0.618),
                                    angularInset: 1
                                )
                                .opacity(isAnimated ? 1 : 0)
                                .foregroundStyle(colorForCategory(category))
                            }
                        }
                        .frame(height: 250)
                        .overlay {
                            VStack(spacing: 5) {
                                Text("Total Expenses")
                                    .font(.headline)
                                Text("€\(totalAmount, specifier: "%.2f")")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                        .shadow(radius: 5)
                        .foregroundStyle(.black)
                        .onAppear {
                            isAnimated = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeOut(duration: 1)) {
                                    isAnimated = true
                                }
                            }
                        }
                }
                .fullScreenCover(isPresented: $showExpenseView) {
                    ExpensesView()
                }
                
                //MARK: Expenses with categories
                NavigationStack {
                    VStack(alignment: .leading) {
                        List {
                            ForEach(categoryTotals.sorted(by: { $0.key < $1.key }), id: \.key) { category, total in
                                HStack {
                                    IconView(category: category)
                                    
                                    Text(category)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Text("€\(total, specifier: "%.0f")")
                                    
                                }
                                .padding(.vertical, 5)
                            }
                            
                        }
                    }
                }

                Button {
                    showingAddScreen = true
                } label: {
                    Text("Add Expense".uppercased())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                        .padding(.horizontal, 100)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showingAddScreen) {
                    AddExpenseView()
                }

            }
            .onAppear {
                totalExpenses = expenses.reduce(0) { $0 + Double($1.amount) }
            }
            .background(.gray.opacity(0.1))
            .navigationTitle("Summary")
        }
        
        
    }
    
    //Delete func
    func deleteExpenses(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let example = Expenses(amount: 10, category: "Food", date: .now, note: "Groceries")
        
        return SummaryView(expense: example)
            .modelContainer(container)
    } catch {
        return Text("Failed")
    }
}
