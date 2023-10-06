//
// LibraryDocumentView.swift
// Copyright (c) 2023 BrightDigit.
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

  struct LibraryDocumentView: View, LoggerCategorized {
    @Environment(\.librarySystemManager) private var librarySystemManager
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    @Environment(\.hubView) var hubView

    @State var object: LibraryDocumentObject
    @Binding var file: LibraryFile?

    var body: some View {
      NavigationSplitView {
        ToolbarView(
          allAllowedContentTypes: librarySystemManager.allAllowedContentTypes,
          object: self.object
        )
        LibraryList(
          items: object.object?.library.items,
          selectedItem: self.$object.selectedItem,
          librarySystemManager: librarySystemManager
        )
        .navigationSplitViewColumnWidth(min: 400, ideal: 400)
        .onChange(of: self.file?.url, self.object.onURLChange(from:to:))
        .onChange(of: self.object.selectedItem, self.object.onSelectionChange)
        .onAppear(perform: {
          self.object.loadURL(self.file?.url, withContext: self.context, using: self.librarySystemManager)
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
        if let image = self.object.object?.bindableImage(withID: self.object.selectedItem) {
          let system = self.librarySystemManager.resolve(image.wrappedValue.metadata.vmSystemID)
          LibraryImageDetailView(image: image, system: system)
        } else {
          Text(.selectImage)
        }
      }
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
      .navigationTitle(self.file?.url.lastPathComponent ?? "Untitled")
    }

    internal init(
      file: Binding<LibraryFile?>,
      object: LibraryDocumentObject = .init()
    ) {
      _file = file
      _object = .init(initialValue: object)
    }
  }
#endif
