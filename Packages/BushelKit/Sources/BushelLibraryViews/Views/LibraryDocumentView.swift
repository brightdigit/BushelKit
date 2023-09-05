//
// LibraryDocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLibrary
  import BushelLibraryEnvironment
  import BushelLogging
  import BushelProgressUI
  import BushelViewsCore
  import Observation
  import SwiftUI

  struct LibraryDocumentView: View, LoggerCategorized {
    internal init(file: Binding<LibraryFile?>,
                  object: LibraryDocumentObject = .init()) {
      _file = file
      _object = .init(initialValue: object)
    }

    @Environment(\.librarySystemManager) private var librarySystemManager
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    @Environment(\.hubView) var hubView

    @State var object: LibraryDocumentObject
    @Binding var file: LibraryFile?

    public var body: some View {
      NavigationSplitView {
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
            allowedContentTypes: librarySystemManager.allAllowedContentTypes,
            onCompletion: self.object.onFileImporterCompleted
          )
          Spacer()
        }.buttonStyle(.plain).padding()
        LibraryList(items: object.object?.library.items, selectedItem: self.$object.selectedItem, librarySystemManager: librarySystemManager)
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
          .sheet(item: self.$object.restoreImageImportProgress) { request in
            ProgressOperationView(request) { imageName in
              Image.resource(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .mask {
                  Circle()
                }.overlay {
                  Circle().stroke()
                }.padding(.horizontal)
            }
          }
          .fileExporter(isPresented: self.$object.presentFileExporter, document: CodablePackageDocument<Library>(), defaultFilename: "Library.bshrilib", onCompletion: { result in
            self.file = self.object.restoreImageFileFrom(result: result)
          })
      } detail: {
        if let image = self.object.object?.bindableImage(withID: self.object.selectedItem) {
          let system = self.librarySystemManager.resolve(image.wrappedValue.metadata.vmSystem)
          LibraryImageDetailView(image: image, system: system)
        } else {
          Text("Select an Image")
        }
      }
      .alert(isPresented: self.$object.presentErrorAlert, error: self.object.error, actions: { error in
        Button {
          guard error.isRecoverable else {
            Task { @MainActor in
              dismiss()
            }
            return
          }
        } label: {
          Text("OK")
        }
      }, message: { error in
        Text(error.localizedDescription)
      })

      .navigationSplitViewStyle(.balanced)
      .navigationTitle(self.file?.url.lastPathComponent ?? "Untitled")
    }
  }
#endif
