//
// RestoreLibrarySideToolbar.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct RestoreLibrarySideToolbar: View {
    @Environment(\.undoManager) var undoManager
    @Binding var shouldSaveFile: Bool
    @Binding var addRestoreImageToLibraryIsVisible: Bool
    let url: URL?
    let selectedFileID: UUID?
    let document: RestoreImageLibraryDocument
    let onImportCompletion: (Result<URL, Error>) -> Void
    let onExportCompletion: (Result<URL, Error>) -> Void
    var body: some View {
      HStack {
        AddRestoreLibraryItemButton(
          addRestoreImageToLibraryIsVisible: self.$addRestoreImageToLibraryIsVisible,
          shouldSaveFile: self.$shouldSaveFile,
          document: self.document,
          onImportCompletion: onImportCompletion,
          onExportCompletion: onExportCompletion
        )
        Divider().padding(.vertical, -6.0).opacity(0.75)
        Button {
          guard let fileID = self.selectedFileID else {
            return
          }
          self.document.trashRestoreImage(withID: fileID)
          //              DispatchQueue.main.async {
          //                self.document.library.items.removeAll {
          //                  $0.id == fileID
          //                }
          //              }
          undoManager?.registerUndo(withTarget: document) { _ in
            document.putBackRestoreImage(withID: fileID)
          }
        } label: {
          Image(systemName: "minus")
        }.disabled(true)
        Divider().padding(.vertical, -6.0).opacity(0.75)
        Button {
          Task {
            await self.document.beginReload(fromURL: self.url)
          }
        } label: {
          Image(systemName: "arrow.clockwise")
        }
        Divider().padding(.vertical, -6.0).opacity(0.75)
        Spacer()
      }
      .buttonStyle(.borderless)
    }
  }
#endif
