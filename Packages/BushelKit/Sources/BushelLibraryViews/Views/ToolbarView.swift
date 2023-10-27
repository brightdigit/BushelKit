//
// ToolbarView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
  import UniformTypeIdentifiers

  struct ToolbarView: View {
    let title: String
    let allAllowedContentTypes: [UTType]
    @Bindable var object: LibraryDocumentObject

    var body: some View {
      HStack {
        Menu {
          Button("Import File...") {
            self.object.presentFileImporter = true
          }
          .accessibilityIdentifier("library:" + title + "toolbar:plus:import")
          .accessibilityLabel("Import File")
          Button("Download From Hub...") {
            self.object.presentHubModal = true
          }
          .accessibilityIdentifier("library:" + title + ":toolbar:plus:download")
          .accessibilityLabel("Download From Hub")
        } label: {
          Image(systemName: "plus")
        }
        .accessibilityLabel("Add Image to Library")
        .accessibilityIdentifier("library:" + title + ":toolbar:plus")
        .accessibilityAction(.default) {
          self.object.presentFileImporter = true
        }
        .accessibilityAction(named: "Download From Hub") {
          self.object.presentHubModal = true
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
        .accessibilityIdentifier("library:" + title + ":toolbar:minus")
        .opacity(self.object.selectedItem == nil ? 0.5 : 1.0)
        .disabled(self.object.selectedItem == nil)

        Spacer()
      }
      .buttonStyle(.plain)
      .padding()
    }
  }
#endif
