//
//  ExpenseRow.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expense.title)
                    .font(.headline)
                Spacer()
                Text(expense.date, format: .dateTime.year().month().day())
                    .foregroundColor(.secondary)
            }
            HStack {
                Text(expense.amount, format: .currency(code: "EUR"))
                    .foregroundColor(.secondary)
                Spacer()
                TypeBadge(type: expense.type)
            }
            
            if let location = expense.locationInfo,
               location.latitude != 0 || location.longitude != 0 {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                    if let name = location.name {
                        Text(name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    } else {
                        Text("Lat: \(location.latitude, specifier: "%.4f"), Lon: \(location.longitude, specifier: "%.4f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}
