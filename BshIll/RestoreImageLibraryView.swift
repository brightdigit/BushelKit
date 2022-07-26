//
//  ContentView.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import SwiftUI
import UniformTypeIdentifiers
import Virtualization


//
//enum RestoreImageLibraryItem : Codable {
//  case folder(RestoreImageLibraryItemFolder)
//  case file(RestoreImageLibraryItemFile)
//}


struct RestoreImageLibraryDocumentView: View {
  internal init(document: Binding<RestoreImageLibraryDocument>, url: URL? = nil, selected: RestoreImageLibraryItemFile? = nil) {
    self.url = url
    self._document = document
    //self._selected = .init(initialValue: selected)
  }
  let url : URL?
  @State var importingURL : URL?
  @Binding var document: RestoreImageLibraryDocument
  //@State var selected : RestoreImageLibraryItemFile?
  
  func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile> {
    guard let index = self.document.library.items.firstIndex(of: file) else {
      preconditionFailure()
    }
    return self.$document.library.items[index]
  }
  @State var addRestoreImageToLibraryIsVisible : Bool = false
    var body: some View {
      NavigationView{
        VStack{
          List(self.document.library.items) { item in
            NavigationLink {
              RestoreImageLibraryItemFileView(file: bindingFor(item))
            } label: {
              Text("\(item.name)")
            }

            
          }
          Spacer()
          Divider().opacity(0.75)
          HStack{
            Button {
              Task {
                await MainActor.run {
                  self.addRestoreImageToLibraryIsVisible = true
                }
              }
            } label: {
              Image(systemName: "plus").padding(.leading, 8.0)
            }.fileImporter(isPresented: self.$addRestoreImageToLibraryIsVisible,allowedContentTypes:
                          UTType.ipswTypes
            ) { result in
              self.importingURL = try? result.get()
            }
            Divider().padding(.vertical, -6.0).opacity(0.75)
            Button {
              
            } label: {
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
        if let url = importingURL {
          let file : RestoreImageLibraryItemFile
          do {
            async let data = try await Task{ try Data(contentsOf: url, options: .uncached) }.value
            
            let sha256 = try await SHA256(hashFromCompleteData: data)
            
            async let vzRestoreImage = try await VZMacOSRestoreImage.loadFromURL(url)
            
            
            
            let restoreImage = try await VirtualizationMacOSRestoreImage(vzRestoreImage: vzRestoreImage, sha256:  sha256)
            
            file = RestoreImageLibraryItemFile(name: restoreImage.metadata.url.deletingPathExtension().lastPathComponent, metadata: restoreImage.metadata, location: .local)
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
        Task {
          await self.document.updateBaseURL(self.url)
        }
      }
    }
}

struct RestoreImageLibraryDocumentView_Previews: PreviewProvider {
  static let data : [RestoreImageLibraryItemFile] = [
    .init(name: "Ventura Beta 3", metadata: .Previews.venturaBeta3),
    .init(name: "Montery 12.4", metadata: .Previews.monterey)
  ]
    static var previews: some View {
      RestoreImageLibraryDocumentView(document: .constant(RestoreImageLibraryDocument(library: .init(items: Self.data))), selected: .init(name: "Ventura Beta 3", metadata: .Previews.venturaBeta3))
    }
}
