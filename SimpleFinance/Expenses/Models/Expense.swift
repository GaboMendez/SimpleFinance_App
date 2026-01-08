//
//  Expense.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import CoreLocation
import Foundation

struct AttachmentInfo: Codable, Identifiable, Hashable {
  let id: UUID
  let fileName: String
  let contentType: String

  var fileURL: URL {
    FileManager.default.documentsDirectory.appendingPathComponent(fileName)
  }
}

// Extend FileManager to get documents directory
extension FileManager {
  var documentsDirectory: URL {
    self.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

struct Expense: Identifiable, Codable, Hashable {
  var id = UUID()
  var title: String
  var type: ExpenseType
  var amount: Double
  var date: Date
  var attachment: AttachmentInfo?
  var locationInfo: LocationInfo?

  init(note: String, type: ExpenseType, amount: Double, date: Date = Date()) {
    self.title = note
    self.type = type
    self.amount = amount
    self.date = date
  }
}

struct LocationInfo: Hashable, Codable {
  let latitude: Double
  let longitude: Double
  let name: String?

  static func == (lhs: LocationInfo, rhs: LocationInfo) -> Bool {
    lhs.latitude == rhs.latitude &&
    lhs.longitude == rhs.longitude &&
    lhs.name == rhs.name
  }
}
