//
//  SimpleFinanceApp.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 19/10/24.
//

import SwiftUI
import SwiftData

@main
struct SimpleFinanceApp: App {
    var body: some Scene {
        WindowGroup {
          TabView {
            Tab("Expenses", systemImage: "list.bullet") {
              NavigationStack {
                ExpenseListView()
              }
            }

            Tab("Charts", systemImage: "chart.pie.fill") {
              NavigationStack {
                ExpenseChartsView()
              }
            }

            Tab("Budget", systemImage: "dollarsign.arrow.circlepath") {
              NavigationStack {
                BudgetView()
              }
            }
          }
        }
    }
}
