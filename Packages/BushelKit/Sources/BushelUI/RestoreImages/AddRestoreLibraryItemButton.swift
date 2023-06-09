//
// AddRestoreLibraryItemButton.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
  import UniformTypeIdentifiers

  struct AddRestoreLibraryItemButton: View {
    @Binding var addRestoreImageToLibraryIsVisible: Bool
    @Binding var shouldSaveFile: Bool

    let document: RestoreImageLibraryDocument
    let onImportCompletion: (Result<URL, Error>) -> Void
    let onExportCompletion: (Result<URL, Error>) -> Void
    var body: some View {
      Button {
        Task {
          await MainActor.run {
            self.addRestoreImageToLibraryIsVisible = true
          }
        }
      } label: {
        Image(systemName: "plus").padding(.leading, 8.0)
      }
      .fileImporter(
        isPresented: $addRestoreImageToLibraryIsVisible,
        allowedContentTypes: UTType.ipswTypes,
        onCompletion: self.onImportCompletion
      )
      .fileExporter(
        isPresented: $shouldSaveFile,
        document: document,
        contentType: .restoreImageLibrary,
        onCompletion: self.onExportCompletion
      )
    }
  }
#endif
