//
// DocumentView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLibrary
  import BushelLibraryEnvironment
  import BushelLocalization
  import BushelLogging
  import BushelProgressUI
  import BushelViewsCore
  import Observation
  import SwiftUI

  struct DocumentView: View, Loggable {
    @Environment(\.librarySystemManager) private var librarySystemManager
    @Environment(\.database) private var database
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    @Environment(\.hubView) var hubView

    @State var object: DocumentObject
    @Binding var file: LibraryFile?

    var title: String {
      self.file?.url.lastPathComponent ?? "Untitled"
    }

    var body: some View {
      NavigationSplitView {
        ToolbarView(
          title: self.title,
          allAllowedContentTypes: librarySystemManager.allAllowedContentTypes,
          object: self.object
        )
        LibraryList(
          accessibilityTitle: title,
          items: object.object?.library.items,
          selectedItem: self.$object.selectedItem,
          librarySystemManager: librarySystemManager
        ).accessibilityIdentifier("library:" + title + ":list")
          .navigationSplitViewColumnWidth(min: 400, ideal: 400)
          .onChange(of: self.file?.url, self.object.onURLChange(from:to:))
          .onChange(of: self.object.selectedItem, self.object.onSelectionChange)
          .onAppear(perform: {
            self.object.loadURL(
              self.file?.url,
              withDatabase: self.database,
              using: self.librarySystemManager
            )
          })
          .sheet(
            isPresented: self.$object.presentHubModal,
            selectedHubImage: self.$object.selectedHubImage,
            onDismiss: self.object.onHubImageSelected,
            self.hubView
          )
          .sheet(item: self.$object.restoreImageImportProgress, content: { request in
            ProgressOperationView(request) {
              Image.resource($0)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .mask { Circle() }
                .overlay { Circle().stroke() }
                .padding(.horizontal)
            }
          })
          .fileExporter(
            isPresented: self.$object.presentFileExporter,
            document: CodablePackageDocument<Library>(),
            defaultFilename: "Library.bshrilib",
            onCompletion: { result in
              self.file = self.object.restoreImageFileFrom(result: result)
            }
          )
      } detail: {
        if let image = self.object.bindableImage {
          @Bindable var bindableImage = image
          let system = self.librarySystemManager.resolve(image.metadata.vmSystemID)
          ImageView(
            image: _bindableImage,
            system: system,
            onSave: self.onSave
          )
          .accessibilityIdentifier("library:" + title + ":selected")
        } else {
          #warning("If no image add buttons to add/download image.")
          Text(.selectImage)
        }
      }
      .accessibilityIdentifier("library:" + title)
      .accessibilityLabel("Library for \(title)")
      .confirmationDialog(
        "Delete Image",
        isPresented: self.$object.presentDeleteImageConfirmation,
        presenting: self.object.queuedRemovalSelectedImage,
        actions: { image in
          Button(
            role: .destructive
          ) {
            Task {
              await self.object.deleteSelectedItem(withID: image.id)
            }
          } label: {
            Text(.libraryConfirmDeleteYes)
          }
          Button(
            role: .cancel,
            action: {
              self.object.cancelRemovalSelectedItem(withID: image.id)
            },
            label: {
              Text(.libraryConfirmDeleteCancel)
            }
          )
        }, message: { image in
          Text(localizedUsingID: LocalizedStringID.libraryDeleteConfirmation, arguments: image.name)
        }
      )
      .alert(
        isPresented: self.$object.presentErrorAlert,
        error: self.object.error,
        actions: { error in
          Button {
            guard error.isRecoverable else {
              Task { @MainActor in
                dismiss()
              }
              return
            }
          } label: {
            Text(.ok)
          }
        }, message: { error in
          Text(error.localizedDescription)
        }
      )
      .navigationSplitViewStyle(.balanced)
      .navigationTitle(title)
    }

    internal init(
      file: Binding<LibraryFile?>,
      object: DocumentObject = .init()
    ) {
      _file = file
      _object = .init(initialValue: object)
    }

    func onSave() {
      let oldSelectedItem = self.object.selectedItem
      self.object.selectedItem = nil
      self.object.selectedItem = oldSelectedItem
    }
  }
#endif
