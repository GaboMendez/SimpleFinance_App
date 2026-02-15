//
//  ExpenseService.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import Foundation

@Observable
final class LocalPersistenceService : PersitenceServing {
  static let shared = LocalPersistenceService()

  private init() {}

  private let expensesKey = "expenses_key"

  private(set) var expenses: [Expense] = []

  func load() {
    expenses = getAll()
  }

  func getAll() -> [Expense] {
    if let savedData = UserDefaults.standard.data(forKey: expensesKey),
       let decodedExpenses = try? JSONDecoder().decode([Expense].self, from: savedData) {
      return decodedExpenses
    }
    return []
  }

  func add(_ expense: Expense) async throws {
    expenses.append(expense)
    saveExpenses()
  }

  func update(_ expense: Expense) async throws {
    if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
      expenses[index] = expense
      saveExpenses()
    }
  }

  func delete(_ expense: Expense) async throws {
    if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
      expenses.remove(at: index)
      saveExpenses()
    }
  }

  func delete(_ ids: [UUID]) async throws {
    expenses.removeAll(where: { ids.contains($0.id) })
    saveExpenses()
  }


  func saveExpenses() {
    if let encoded = try? JSONEncoder().encode(expenses) {
      UserDefaults.standard.set(encoded, forKey: expensesKey)
    }
  }
}

// SPLASH SCREEN WITH ANIMATIONS
