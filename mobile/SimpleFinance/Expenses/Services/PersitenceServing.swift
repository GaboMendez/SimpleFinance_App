//
//  Untitled.swift
//  SimpleFinance
//
//  Created by Gabriel Mendez Reyes on 9/1/26.
//

import Foundation

protocol PersitenceServing {
  func load() async throws
  func getAll() async throws -> [Expense]
  func add(_ expense: Expense) async throws
  func update(_ expense: Expense) async throws
  func delete(_ expense: Expense) async throws
  func delete(_ ids: [UUID]) async throws
 
 
  var expenses: [Expense] { get }
}
