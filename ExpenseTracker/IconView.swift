//
//  IconView.swift
//  ExpenseTracker
//
//  Created by Fuad Salehov on 08.05.25.
//

import SwiftUI

struct IconView: View {
    let category: String

    var body: some View {
        ZStack {
            Circle()
                .fill(colorForCategory(category))
                .frame(width: 40, height: 40)

            Image(systemName: iconNameForCategory(category))
                .foregroundStyle(.white)
        }
    }

    func iconNameForCategory(_ category: String) -> String {
        switch category {
        case "Food": return "fork.knife"
        case "Transportation": return "car.fill"
        case "Shopping": return "cart.fill"
        default: return "basket.fill"
        }
    }

    
}

func colorForCategory(_ category: String) -> Color {
    switch category {
    case "Food": return .orange
    case "Transportation": return .blue
    case "Shopping": return .purple
    default: return .green
    }
}
#Preview {
    IconView(category: "Food")
}
