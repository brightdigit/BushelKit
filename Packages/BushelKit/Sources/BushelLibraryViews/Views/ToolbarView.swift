//
// ToolbarView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
  import UniformTypeIdentifiers

  struct ToolbarView: View {
    let allAllowedContentTypes: [UTType]
    @Bindable var object: LibraryDocumentObject

    var body: some View {
      HStack {
        Menu {
          Button("Import File...") {
            self.object.presentFileImporter = true
          }
          Button("Download From Hub...") {
            self.object.presentHubModal = true
          }
        } label: {
          Image(systemName: "plus")
        }
        .fileImporter(
          isPresented: self.$object.presentFileImporter,
          allowedContentTypes: allAllowedContentTypes,
          onCompletion: self.object.onFileImporterCompleted
        )
        Button {
          self.object.queueRemovalSelectedItem()
        } label: {
          VStack {
            Spacer()
            Image(systemName: "minus")
            Spacer()
          }.frame(height: 12).contentShape(Rectangle())
        }
        .opacity(self.object.selectedItem == nil ? 0.5 : 1.0)
        .disabled(self.object.selectedItem == nil)

        Spacer()
      }
      .buttonStyle(.plain)
      .padding()
    }
  }
#endif
