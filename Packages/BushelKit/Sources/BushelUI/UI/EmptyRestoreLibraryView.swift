//
// EmptyRestoreLibraryView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct EmptyRestoreLibraryView: View {
    let selectableFileID: UUID?
    let onImportAction: () -> Void
    let onSelectAction: (UUID) -> Void

    func onSelectionAction(_ fileID: UUID) -> () -> Void {
      {
        self.onSelectAction(fileID)
      }
    }

    var body: some View {
      VStack(alignment: .leading) {
        EmptyLibraryActionButton(imageSystemName: "plus", titleID: .importRestoreImage, action: self.onImportAction).padding(8.0)

        if let fileID = selectableFileID {
          EmptyLibraryActionButton(imageSystemName: "filemenu.and.selection", titleID: .selectRestoreImage, action: self.onSelectionAction(fileID)).padding(8.0)
        }
      }.buttonStyle(BorderlessButtonStyle()).foregroundColor(.primary)
    }
  }
#endif
