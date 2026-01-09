//
//  ExpensesList.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 19/10/24.
//

import SwiftUI
import Combine
import PhotosUI
import UniformTypeIdentifiers
import Observation
import Charts

struct ExpenseListView: View {
  private var viewModel = ExpenseListViewModel(
    persistenceService: RemotePersistenceService.shared
  )
  @State private var showExpenseForm = false
  @State private var showingAlert = false
  @State private var selectedExpense: Expense?
  @State private var expenseToDelete: Expense?
  @State private var selection = Set<UUID>()

  @Environment(\.editMode) private var editMode

  var body: some View {
    List(viewModel.expenses, selection: $selection) { expense in
        ExpenseRow(expense: expense)
          .swipeActions {
            Button {
              expenseToDelete = expense
              showingAlert = true
            } label: {
              Label("Delete", systemImage: "trash")
            }
            .tint(.red)

            Button {
              selectedExpense = expense
            } label: {
              Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
          }
    }
    .sheet(isPresented: $showExpenseForm) {
      NewExpenseFormView()
        .presentationDetents([.large])
        .interactiveDismissDisabled(true)
    }
    .sheet(item: $selectedExpense) { expense in
      EditExpenseFormView(expense: expense)
        .presentationDetents([.large])
        .interactiveDismissDisabled(true)
    }
    .sheet(item: $selectedExpense) { expense in
      EditExpenseFormView(expense: expense)
        .presentationDetents([.large])
        .interactiveDismissDisabled(true)
    }
    .alert("Delete Expense", isPresented: $showingAlert) {
      Button("Delete", role: .destructive) {
        if let expenseToDelete {
          Task {
            await viewModel.delete(expenseToDelete)
          }
        }
      }

      Button("Cancel", role: .cancel) {

      }
    }
    .navigationTitle("Expenses")
    .task {
      await viewModel.load()
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        EditButton()
      }

      ToolbarItemGroup(placement: .topBarTrailing) {
        if !selection.isEmpty {
          Button {
            Task {
              await viewModel.delete(Array(selection))
            }
          } label: {
            Image(systemName: "trash")
          }
        }

        Button {
          showExpenseForm = true
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ExpenseListView()
  }
}
