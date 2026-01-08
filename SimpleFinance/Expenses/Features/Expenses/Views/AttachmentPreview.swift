//
//  AttachmentPreview.swift
//  SimpleFinance
//
//  Created by Libranner Leonel Santos Espinal on 27/10/24.
//

import SwiftUI

struct AttachmentPreview: View {
  let url: URL
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      QuickLookPreview(url: url)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Close") {
              dismiss()
            }
          }
        }
    }
  }
}
