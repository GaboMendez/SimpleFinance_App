//
//  ExpenseReportService.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 1/11/24.
//

import Foundation

struct ExpenseReportService {
  let expenses: [Expense]

  func expensesByMonth() -> [ExpenseByMonth] {
    let calendar = Calendar.current
    let grouped = Dictionary(grouping: expenses) { expense -> String in
      let components = calendar.dateComponents([.year, .month], from: expense.date)
      return String(format: "%04d-%02d", components.year!, components.month!)
    }
    return grouped.map { (month, expenses) in
      ExpenseByMonth(month: month, total: expenses.reduce(0) { $0 + $1.amount })
    }.sorted { $0.month < $1.month }
  }

  func expensesByType() -> [ExpenseByType] {
    let grouped = Dictionary(grouping: expenses, by: { $0.type })

    return grouped.map { (type, expenses) in
      ExpenseByType(type: type, total: expenses.reduce(0) { $0 + $1.amount })
    }.sorted { $0.type.title < $1.type.title }
  }

  func expenseTypeByMonth() -> [ExpenseTypeByMonth] {
    let calendar = Calendar.current
    let grouped = Dictionary(grouping: expenses) { expense -> MonthTypeKey in
      let components = calendar.dateComponents([.year, .month], from: expense.date)
      let month = String(format: "%04d-%02d", components.year!, components.month!)
      return MonthTypeKey(month: month, type: expense.type)
    }
    return grouped.map { (key, expenses) in
      ExpenseTypeByMonth(
        month: key.month,
        type: key.type,
        total: expenses.reduce(0) { $0 + $1.amount }
      )
    }
  }
}

private extension ExpenseReportService {
  struct MonthTypeKey: Hashable {
    let month: String
    let type: ExpenseType
  }
}
