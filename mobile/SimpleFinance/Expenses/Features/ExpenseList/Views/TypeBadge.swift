//
//  TypeBadge.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct TypeBadge: View {
  let type: ExpenseType

  var body: some View {
    HStack(spacing: 4) {
      Image(systemName: type.icon)
      Text(type.title)
    }
    .font(.caption)
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(type.color.opacity(0.2))
    .foregroundColor(type.color)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}
