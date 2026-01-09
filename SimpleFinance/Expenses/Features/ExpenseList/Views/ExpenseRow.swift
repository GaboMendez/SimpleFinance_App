//
//  ExpenseRow.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    
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
            }
        }
    }
}
