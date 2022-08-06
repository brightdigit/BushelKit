//
// RestoreImageLibraryView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct RestoreImageLibraryDocumentView: View {
  internal init(document: Binding<RestoreImageLibraryDocument>, url: URL? = nil, selected _: RestoreImageLibraryItemFile? = nil) {
    self.url = url
    _document = document
  }

  let url: URL?
  @State var importingURL: URL?
  @Binding var document: RestoreImageLibraryDocument

  func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile> {
    guard let index = document.library.items.firstIndex(of: file) else {
      preconditionFailure()
    }
    return $document.library.items[index]
  }

  @State var addRestoreImageToLibraryIsVisible: Bool = false
  var body: some View {
    NavigationView {
      VStack {
        List(self.document.library.items) { item in
          NavigationLink {
            RestoreImageLibraryItemFileView(file: bindingFor(item))
          } label: {
            Text("\(item.name)")
          }
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
    }.task(id: self.importingURL) {
      let imageManager = self.importingURL.flatMap { url in
        try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
      }.flatMap { typeID in
        UTType(typeID)
      }.flatMap { utType in
        AnyImageManagers.imageManager(forContentType: utType)
      }
      if let url = importingURL, let imageManager = imageManager {
        let file: RestoreImageLibraryItemFile
        do {
          async let data = try await Task { try Data(contentsOf: url, options: .uncached) }.value

          let sha256 = try await SHA256(hashFromCompleteData: data)
          let accessor = URLAccessor(url: url, sha256: sha256)

          let restoreImage = try await imageManager.load(from: accessor, using: FileRestoreImageLoader())

          file = RestoreImageLibraryItemFile(restoreImage: restoreImage)

        } catch {
          dump(error)
          return
        }
        await MainActor.run {
          self.document.library.items.append(file)
          self.importingURL = nil
        }
      }
    }.onAppear {
      self.document.updateBaseURL(self.url)
    }
  }
}
