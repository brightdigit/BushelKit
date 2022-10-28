//
// RestoreImageLibraryDocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  struct RestoreImageLibraryDocumentView: View {
    internal init(
      document: RestoreImageLibraryDocument,
      url: URL?,
      activeImports: [ActiveRestoreImageImport] = .init(),
      selected: RestoreImageLibraryItemFile? = nil
    ) {
      _url = .init(initialValue: url)
      self.document = document
      _window = .init(wrappedValue: NSApplication.shared.keyWindow)
      _activeImports = .init(initialValue: activeImports)
      initialSelectedFile = selected
    }

    @Environment(\.undoManager) var undoManager
    @State var window: NSWindow?
    @State var url: URL?
    @State var shouldSaveFile = false
    @State var selectedFileID: UUID?
    @State var selectableFileID: UUID?
    let initialSelectedFile: RestoreImageLibraryItemFile?
    @State var importingURL: URL?
    @State var activeImports: [ActiveRestoreImageImport]
    @ObservedObject var document: RestoreImageLibraryDocument

    var initialSelectedFileBinding: Binding<RestoreImageLibraryItemFile>? {
      initialSelectedFile.flatMap($document.library.optionalBindingFor(_:))
    }

    @State var addRestoreImageToLibraryIsVisible = false

    func importFile(_ file: RestoreImageLibraryItemFile, fromURL newImageURL: URL) async {
      await document.importFile(file)
      importingURL = nil
      activeImports.removeAll { activeImport in
        activeImport.sourceURL == newImageURL
      }
    }

    // swiftlint:disable:next function_body_length
    func importRestoreImage() async {
      let oldLibrary = document.library
      guard let newImageURL = importingURL else {
        Self.logger.warning("no url")
        return
      }
      guard let imageManager = AnyImageManagers.imageManager(forURL: newImageURL) else {
        Self.logger.warning("new image manager for \(newImageURL.path)")
        return
      }

      DispatchQueue.main.async {
        self.activeImports.append(.init(sourceURL: newImageURL))
      }
      let file: RestoreImageLibraryItemFile
      do {
        file = try await imageManager.restoreLibraryItem(newImageURL)
      } catch {
        Self.logger.error(
          "unable to create restore Library item for \(newImageURL): \(error.localizedDescription)"
        )
        activeImports.removeAll { activeImport in
          activeImport.sourceURL == newImageURL
        }
        return
      }
      await
        importFile(file, fromURL: newImageURL)

      undoManager?.registerUndo(withTarget: document, handler: { document in
        DispatchQueue.main.async {
          document.library = oldLibrary
        }
      })
    }

    func invalidateURL() {
      if let url = url {
        document.updateBaseURL(url)
      } else {
        DispatchQueue.main.async {
          self.shouldSaveFile = true
        }
      }
    }

    var body: some View {
      NavigationView {
        VStack {
          if !activeImports.isEmpty || !self.document.library.items.isEmpty {
            RestoreLibraryItemsList(
              activeImports: self.activeImports,
              listContainer: self._document,
              selectedFileID: self.$selectedFileID
            )
          } else {
            Button {
              self.addRestoreImageToLibraryIsVisible = true
            } label: {
              Image(systemName: "plus")
              Text(.importFirstImage)
            }.padding().buttonStyle(LinkButtonStyle())
          }
          Spacer()
          Divider().opacity(0.75)
          RestoreLibrarySideToolbar(
            shouldSaveFile: $shouldSaveFile,
            addRestoreImageToLibraryIsVisible: $addRestoreImageToLibraryIsVisible,
            url: url,
            selectedFileID: selectedFileID,
            document: document,
            onImportCompletion: { result in
              do {
                self.importingURL = try result.get()
              } catch {
                Self.logger.error("unable to import error: \(error.localizedDescription)")
              }
            },
            onExportCompletion: { result in
              self.window?.close()
              self.window = nil
              if let url = try? result.get() {
                Windows.openDocumentAtURL(url)
              }
            }
          )
          .padding(.vertical, 4.0)
          .fixedSize(horizontal: false, vertical: true)
          .offset(x: 0.0, y: -2.0)
        }
        .frame(minWidth: 200, maxWidth: 500)

        if let binding = self.initialSelectedFileBinding {
          RestoreImageLibraryItemFileView(file: binding)
        } else {
          EmptyRestoreLibraryView(
            selectableFileID: self.selectableFileID,
            onImportAction: {
              DispatchQueue.main.async {
                self.addRestoreImageToLibraryIsVisible = true
              }
            },
            onSelectAction: { fileID in
              DispatchQueue.main.async {
                self.selectedFileID = fileID
              }
            }
          )
        }
      }
      .task(id: self.importingURL) {
        if importingURL != nil {
          await importRestoreImage()
        }
      }
      .onChange(of: self.url) { _ in
        self.invalidateURL()
      }
      .onAppear {
        self.invalidateURL()
      }
      .onReceive(self.document.$library) { library in
        DispatchQueue.main.async {
          self.selectableFileID = library.items.randomElement()?.id
        }
      }
    }
  }

  #if canImport(Virtualization) && arch(arm64)
    struct RestoreImageLibraryDocumentView_Previews: PreviewProvider {
      static var previews: some View {
        RestoreImageLibraryDocumentView(
          document: RestoreImageLibraryDocument(
            library: .init(items: Self.data)
          ),

          url: .init(
            fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
          ),
          activeImports: [
            .init(
              sourceURL: .init(
                fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
              )
            )
          ],
          selected: .init(
            id: .init(),
            metadata: .Previews.venturaBeta3,
            name: "Ventura Beta 3",
            fileAccessor: URLAccessor(
              url: .init(
                fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
              )
            )
          )
        )

        RestoreImageLibraryDocumentView(
          document: RestoreImageLibraryDocument(),
          url: .init(
            fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
          ),
          activeImports: [],
          selected: nil
        )
      }
    }
  #endif
#endif
