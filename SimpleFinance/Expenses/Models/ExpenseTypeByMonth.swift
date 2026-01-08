//
//  ExpenseTypeByMonth.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 1/11/24.
//

import Foundation

struct ExpenseTypeByMonth: Identifiable {
  let id = UUID()
  let month: String
  let type: ExpenseType
  let total: Double
}
