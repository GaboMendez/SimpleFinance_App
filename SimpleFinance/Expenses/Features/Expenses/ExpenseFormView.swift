//
//  ExpenseFormView.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct EditExpenseFormView: View {
var viewModel: ExpenseViewModel

  init(expense: Expense) {
    self.viewModel =  ExpenseViewModel(
        isNewExpense: false,
        expense: expense,
        persistentService: RemotePersistenceService.shared
      )
  }

  var body: some View {
    ExpenseFormView(viewModel: viewModel)
  }
}

struct NewExpenseFormView: View {
  var viewModel = ExpenseViewModel(isNewExpense: true, persistentService: RemotePersistenceService.shared)

  var body: some View {
    ExpenseFormView(viewModel: viewModel)
  }
}

struct ExpenseFormView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var showingAttachmentSheet = false
  @State private var showingImagePicker = false
  @State private var showingDocumentPicker = false
  @State private var showingCamera = false
  @State private var showingAttachmentPreview = false

  @State private var showingLocationPicker = false

  @Bindable var viewModel: ExpenseViewModel

  var body: some View {
    let _ = Self._printChanges()
    NavigationStack {
      Form {
        Section {
          TextField("Enter Amount", value: $viewModel.expense.amount, format: .number)
            .keyboardType(.decimalPad)
            .font(.system(size: 50))
        } header: {
          HStack {
            Image(systemName: "dollarsign")
            Text("Amount")
          }
        }

        Section {
          TextField("Enter Title", text: $viewModel.expense.title)
          Picker("Type", selection: $viewModel.expense.type) {
            ForEach(ExpenseType.allCases) { type in
              Text(type.title)
                .tag(type)
            }
          }
          DatePicker("Date", selection: $viewModel.expense.date, displayedComponents: .date)
        } header: {
          HStack {
            Image(systemName: "note.text")
            Text("Expense Details")
          }
        }

        Section {
          if let attachment = viewModel.expense.attachment {
            Text(attachment.fileName)
              .onTapGesture {
                showingAttachmentPreview = true
              }
            Button(role: .destructive) {
              viewModel.deleteAttachment()
            } label: {
              Label(
                "Delete Attachment",
                systemImage: "trash"
              )
              .foregroundStyle(.red)
            }
          } else {
            Button {
              showingAttachmentSheet = true
            } label: {
              HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Attachment")
              }
            }
          }
        } header: {
          HStack {
            Image(systemName: "paperclip")
            Text("Attachments")
          }
        }

        Section {
          Button {
            showingLocationPicker = true
          } label: {
            HStack {
              Image(systemName: "location.circle.fill")
              //TODO: Colocar información de Localización aquí
            }
          }
        } header: {
          HStack {
            Image(systemName: "map")
            Text("Location")
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            Task {
              await viewModel.addExpense()
              dismiss()
            }
          }
        }
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") {
            dismiss()
          }
        }
      }
      .confirmationDialog("Add Attachment", isPresented: $showingAttachmentSheet) {
        Button("Take Photo") {
          showingCamera = true
        }
        Button("Choose Photo") {
          showingImagePicker = true
        }
        Button("Choose PDF") {
          showingDocumentPicker = true
        }
        Button("Cancel", role: .cancel) {}
      }
      .sheet(isPresented: $showingImagePicker) {
        ImagePicker(completion: viewModel.handleImageSelection)
      }
      .sheet(isPresented: $showingCamera) {
        Camera(completion: viewModel.handleImageSelection)
      }
      .sheet(isPresented: $showingAttachmentPreview) {
        if let attachment = viewModel.expense.attachment {
          AttachmentPreview(url: attachment.fileURL)
        }
      }
      .sheet(isPresented: $showingLocationPicker) {
        //TODO: Implementat location picker
      }
      .fileImporter(
        isPresented: $showingDocumentPicker,
        allowedContentTypes: [.pdf],
        allowsMultipleSelection: false
      ) { result in
        viewModel.handleDocumentSelection(result)
      }
    }
  }
}
