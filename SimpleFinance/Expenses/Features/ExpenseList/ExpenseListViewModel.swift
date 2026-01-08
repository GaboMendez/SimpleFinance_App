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
  private let persistenceService: LocalPersistenceService
  var expenses: [Expense] {
    persistenceService.expenses
  }

  init(persistenceService: LocalPersistenceService) {
    self.persistenceService = persistenceService
    self.persistenceService.load()
  }

  func delete(_ expense: Expense) {
    persistenceService.delete(expense)
  }

  func delete(_ ids: [UUID]) {
    persistenceService.delete(ids)
  }
}

