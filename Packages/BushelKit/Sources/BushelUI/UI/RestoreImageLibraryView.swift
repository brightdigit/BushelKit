//
// RestoreImageLibraryView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  struct RestoreImageLibraryDocumentView: View {
    internal init(
      document: Binding<RestoreImageLibraryDocument>,
      url: URL?,
      activeImports: [ActiveRestoreImageImport] = .init(),
      selected: RestoreImageLibraryItemFile? = nil
    ) {
      _url = .init(initialValue: url)
      _document = document
      _window = .init(wrappedValue: NSApplication.shared.keyWindow)
      _activeImports = .init(initialValue: activeImports)
      initialSelectedFile = selected
    }

    @State var window: NSWindow?
    @State var url: URL?
    @State var shouldSaveFile: Bool = false
    @State var selectedFileID: UUID?
    let initialSelectedFile: RestoreImageLibraryItemFile?
    @State var importingURL: URL?
    @State var activeImports: [ActiveRestoreImageImport]
    @Binding var document: RestoreImageLibraryDocument

    var initialSelectedFileBinding: Binding<RestoreImageLibraryItemFile>? {
      initialSelectedFile.flatMap(optionalBindingFor(_:))
    }

    func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile> {
      guard let index = document.library.items.firstIndex(of: file) else {
        preconditionFailure()
      }
      return $document.library.items[index]
    }

    func optionalBindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile>? {
      guard let index = document.library.items.firstIndex(of: file) else {
        return nil
      }
      return $document.library.items[index]
    }

    @State var addRestoreImageToLibraryIsVisible: Bool = false
    fileprivate func importRestoreImage() async {
      let imageManager = importingURL.flatMap { url in
        try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
      }.flatMap { typeID in
        UTType(typeID)
      }.flatMap { utType in
        AnyImageManagers.imageManager(forContentType: utType)
      }
      if let newImageURL = importingURL, let imageManager = imageManager {
        DispatchQueue.main.async {
          self.activeImports.append(.init(sourceURL: newImageURL))
        }
        let file: RestoreImageLibraryItemFile
        do {
          let accessor = URLAccessor(url: newImageURL)
          let restoreImage = try await imageManager.load(from: accessor, using: FileRestoreImageLoader())
          guard let restoreImageFile = RestoreImageLibraryItemFile(loadFromImage: restoreImage) else {
            throw MachineError.undefinedType("invalid restore image", restoreImage)
          }
          file = restoreImageFile
        } catch {
          dump(error)
          activeImports.removeAll { activeImport in
            activeImport.sourceURL == newImageURL
          }
          return
        }
        await MainActor.run {
          self.document.importFile(file)
          self.importingURL = nil
          self.activeImports.removeAll { activeImport in
            activeImport.sourceURL == newImageURL
          }
        }
      }
    }

    fileprivate func invalidateURL() {
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
          if activeImports.count + self.document.library.items.count > 0 {
            List {
              if activeImports.count > 0 {
                Section {
                  ScrollView {
                    ForEach(activeImports) { activeImport in
                      HStack {
                        ProgressView().scaleEffect(0.4)
                        Text("Importing \(activeImport.sourceURL.lastPathComponent)...")
                      }.padding(-10.0)
                    }.font(.caption)
                  }
                }.frame(maxHeight: 100)
              }
              Section {
                ForEach(self.document.library.items) { item in

                  NavigationLink(tag: item.id, selection: self.$selectedFileID) {
                    VStack {
                      RestoreImageLibraryItemFileView(file: bindingFor(item)).padding()
                      Spacer()
                    }
                  } label: {
                    Text("\(item.name)")
                  }
                }
              }
            }
          } else {
            Button {
              self.addRestoreImageToLibraryIsVisible = true
            } label: {
              Image(systemName: "plus")
              Text("Import First Image")
            }.padding().buttonStyle(LinkButtonStyle())
          }
          Spacer()
          Divider().opacity(0.75)
          HStack {
            Button {
              Task {
                await MainActor.run {
                  self.addRestoreImageToLibraryIsVisible = true
                }
              }
            } label: {
              Image(systemName: "plus").padding(.leading, 8.0)
            }.fileImporter(isPresented: self.$addRestoreImageToLibraryIsVisible, allowedContentTypes:
              UTType.ipswTypes) { result in

                self.importingURL = try? result.get()
              }.fileExporter(isPresented: $shouldSaveFile, document: self.document, contentType: .restoreImageLibrary) { result in
                dump(self.window)
                self.window?.close()
                self.window = nil
                if let url = try? result.get() {
                  Windows.openDocumentAtURL(url)
                }
              }
            Divider().padding(.vertical, -6.0).opacity(0.75)
            Button {} label: {
              Image(systemName: "minus")
            }
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
          }.buttonStyle(.borderless).padding(.vertical, 4.0).fixedSize(horizontal: false, vertical: true).offset(x: 0.0, y: -2.0)
        }
        .frame(minWidth: 200, maxWidth: 500)

        if let binding = self.initialSelectedFileBinding {
          RestoreImageLibraryItemFileView(file: binding)
        } else {
          VStack(alignment: .leading) {
            Button {
              DispatchQueue.main.async {
                self.addRestoreImageToLibraryIsVisible = true
              }
            } label: {
              HStack {
                Image(systemName: "plus").resizable().aspectRatio(1.0, contentMode: .fit).foregroundColor(.accentColor).frame(height: 24.0)
                Spacer().frame(width: 12.0)
                Text("Import a Restore Image").font(.custom("Raleway", size: 24.0))
              }
            }.padding(8.0)

            if let fileID = self.document.library.items.randomElement()?.id {
              Button {
                DispatchQueue.main.async {
                  self.selectedFileID = fileID
                }
              } label: {
                HStack {
                  Image(systemName: "filemenu.and.selection")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .foregroundColor(.accentColor)
                    .frame(height: 24.0)
                  Spacer().frame(width: 12.0)
                  Text("Select a Restore Image").font(.custom("Raleway", size: 24.0))
                }
              }.padding(8.0)
            }

          }.buttonStyle(BorderlessButtonStyle()).foregroundColor(.primary)
        }

      }.task(id: self.importingURL) {
        await importRestoreImage()
      }.onChange(of: self.url) { _ in
        self.invalidateURL()
      }.onAppear {
        self.invalidateURL()
      }
    }
  }

  #if canImport(Virtualization) && arch(arm64)
    struct RestoreImageLibraryDocumentView_Previews: PreviewProvider {
      static var previews: some View {
        RestoreImageLibraryDocumentView(
          document: .constant(RestoreImageLibraryDocument(
            library: .init(items: Self.data))
          ),
          url: .init(
            fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
          ),
          activeImports: [
            .init(sourceURL: .init(fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"))
          ],
          selected: .init(
            id: .init(),
            name: "Ventura Beta 3",
            metadata: .Previews.venturaBeta3,
            fileAccessor: URLAccessor(
              url: .init(
                fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
              )
            )
          )
        )

        RestoreImageLibraryDocumentView(
          document: .constant(RestoreImageLibraryDocument()),
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
