//
// ToolbarView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelAccessibility
  import SwiftUI
  import UniformTypeIdentifiers

  @MainActor
  internal struct ToolbarView: View {
    let title: String
    let allAllowedContentTypes: [UTType]
    @Bindable var object: DocumentObject

    var addMenu: some View {
      Menu {
        Button(.importImage) { @MainActor in
          self.object.presentFileImporter = true
        }
        .accessibilityIdentifier(
          Library.libraryToolbarAction(
            title, "import"
          ).identifier
        )
        .accessibilityLabel("Import File")
        Button(.downloadImage) {
          self.object.presentHubModal = true
        }
        .accessibilityIdentifier(
          Library.libraryToolbarAction(
            title, "download"
          ).identifier
        )
        .accessibilityLabel("Download From Hub")
      } label: {
        Image(systemName: "plus")
      }
      .accessibilityLabel("Add Image to Library")
      .accessibilityIdentifier(Library.libraryToolbar(title).identifier)
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
    }

    var removeButton: some View {
      Button {
        self.object.queueRemovalSelectedItem()
      } label: {
        VStack {
          Spacer()
          Image(systemName: "minus")
          Spacer()
        }.frame(height: 12).contentShape(Rectangle())
      }
      .accessibilityIdentifier(
        Library.libraryToolbarAction(
          title, "minus"
        ).identifier
      )
      .opacity(self.object.selectedItem == nil ? 0.5 : 1.0)
      .disabled(self.object.selectedItem == nil)
    }

    var synchronizeButton: some View {
      Button {
        self.object.beginSynchronize()
      } label: {
        VStack {
          Spacer()
          Image(systemName: "arrow.clockwise")
          Spacer()
        }
      }.frame(height: 12).contentShape(Rectangle()).hidden()
    }

    var body: some View {
      HStack {
        addMenu
        removeButton
        synchronizeButton
        Spacer()
      }
      .buttonStyle(.plain)
      .padding()
    }
  }
#endif
