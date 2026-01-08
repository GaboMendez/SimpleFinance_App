//
//  BudgetView.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 26/10/24.
//

import SwiftUI

struct BudgetView: View {
  @State private var totalBudget: Double = 0
  @State private var savingsGoal: Double = 200
  @State private var expensesAmount = 100.0

  var body: some View {
    Form {
      Section(header: Text("Budget")) {
        LabeledContent("Total Budget") {
          TextField("Amount", value: $totalBudget, format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
        }
        .foregroundStyle(.primary)

        LabeledContent("Expenses") {
          Text(expensesAmount, format: .currency(code: "USD"))
        }
        .foregroundStyle(.secondary)
      }

      Section(header: Text("Savings Goal")) {
        LabeledContent("Current Savings") {
          Text(savings, format: .currency(code: "USD"))
        }

        LabeledContent("Goal") {
          TextField("Amount", value: $savingsGoal, format: .number)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
        }

        VStack(alignment: .leading) {
          Text("Progress: \(Int(progress * 100))%")
          ProgressView(value: progress)
            .progressViewStyle(.linear)
            .tint(progressColor)
        }
        .foregroundStyle(progressColor)
      }
    }
    .navigationTitle("Budget")
    .onAppear {
      let service = LocalPersistenceService.shared
      expensesAmount = service.expenses.reduce(0) { $0 + $1.amount }
    }
  }

  private var progressColor: Color {
    switch progress {
    case ..<0.5:
      return .red
    case ..<1.0:
      return .yellow
    default:
      return .green
    }
  }

  private var savings: Double {
    totalBudget - expensesAmount
  }

  private var progress: Double {
    guard savings > 0 else {
      return 0
    }
    let percentage = min(savings / savingsGoal, 1.0)
    return percentage > 0 ? percentage : 0
  }
}

#Preview {
    BudgetView()
}
