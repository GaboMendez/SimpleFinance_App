import SwiftUI
import Observation

@Observable
class ExpenseViewModel {
  var expense: Expense
  let isNewExpense: Bool
  private(set) var tempAttachmentData: (data: Data, fileName: String, contentType: String)?

  private let persistentService: PersitenceServing

  init(
    isNewExpense: Bool,
    expense: Expense = .init(note: "", type: .food, amount: 0),
    persistentService: PersitenceServing
  ) {
    self.expense = expense
    self.isNewExpense = isNewExpense
    self.persistentService = persistentService
  }

  func updateLocation(_ locationInfo: LocationInfo?) {
    expense.locationInfo = locationInfo
  }

  func saveAttachment() {
    guard let (data, fileName, _) = tempAttachmentData else { return }
    let fileURL = FileManager.default.documentsDirectory.appendingPathComponent(fileName)
    do {
      try data.write(to: fileURL)
    } catch {
      expense.attachment = nil
      print("Error saving attachment: \(error)")
    }
  }

  func deleteAttachment() {
    guard let attachment = expense.attachment else { return }

    do {
      try FileManager.default.removeItem(at: attachment.fileURL)
    } catch {
      print("Error deleting attachment: \(error)")
    }

    tempAttachmentData = nil
    expense.attachment = nil
  }

  func handleImageSelection(_ image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
    let fileName = UUID().uuidString + ".jpg"
    tempAttachmentData = (imageData, fileName, "image/jpeg")
    expense.attachment = AttachmentInfo(id: UUID(), fileName: fileName, contentType: "image/jpeg")
  }

  func handleDocumentSelection(_ result: Result<[URL], Error>) {
    guard case .success(let urls) = result,
          let url = urls.first,
          url.startAccessingSecurityScopedResource() else { return }
    defer { url.stopAccessingSecurityScopedResource() }

    do {
      let data = try Data(contentsOf: url)
      let fileName = url.lastPathComponent
      tempAttachmentData = (data, fileName, "application/pdf")
      expense.attachment = AttachmentInfo(id: UUID(), fileName: fileName, contentType: "application/pdf")
    } catch {
      print("Error preparing PDF: \(error)")
    }
  }

  func addExpense() async {
    if tempAttachmentData != nil {
      saveAttachment()
    }

    do {
      if isNewExpense {
        try await persistentService.add(expense)
      } else {
        try await persistentService.update(expense)
      }
    } catch {
      print("Error saving expense: \(error)")
    }
  }
}
