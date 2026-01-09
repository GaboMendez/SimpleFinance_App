//
//  ExpenseViewModel.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import Foundation
import Observation

@Observable
class ExpenseListViewModel {
  private let persistenceService: PersitenceServing
  var expenses: [Expense] {
    persistenceService.expenses
  }

  init(persistenceService: PersitenceServing) {
    self.persistenceService = persistenceService
  }
  
  func load() async {
    do {
      try await persistenceService.load()
    } catch {
      print("Error loading expenses: \(error)")
    }
  }

  func delete(_ expense: Expense) async {
    do {
      try await persistenceService.delete(expense)
    } catch {
      print("Error deleting expense: \(error)")
    }
  }

  func delete(_ ids: [UUID]) async {
    do {
      try await persistenceService.delete(ids)
    } catch {
      print("Error deleting expenses: \(error)")
    }
  }
}

