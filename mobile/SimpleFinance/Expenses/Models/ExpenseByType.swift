//
//  ExpenseByType.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 1/11/24.
//

import Foundation

struct ExpenseByType: Identifiable {
  let id = UUID()
  let type: ExpenseType
  let total: Double
}
