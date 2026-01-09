//
//  ExpenseType.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

enum ExpenseType: String, Hashable, CaseIterable, Identifiable, Codable {
  case food
  case transport
  case entertainment
  case shopping
  case utilities
  case other

  var id: String { self.rawValue }

  var title: String {
    rawValue.capitalized
  }
}

extension ExpenseType {
  var color: Color {
    switch self {
    case .food:
      return .green
    case .transport:
      return .blue
    case .entertainment:
      return .purple
    case .shopping:
      return .orange
    case .utilities:
      return .red
    case .other:
      return .gray
    }
  }

  var icon: String {
    switch self {
    case .food:
      return "fork.knife"
    case .transport:
      return "car.fill"
    case .entertainment:
      return "tv.fill"
    case .shopping:
      return "cart.fill"
    case .utilities:
      return "bolt.fill"
    case .other:
      return "square.fill"
    }
  }
}
