import SwiftUI


class RestoreImageLibraryDocumentObject : ObservableObject {
  internal init(document: Binding<RestoreImageLibraryDocument>) {
    self._document = document
  }
  
  @Binding var document: RestoreImageLibraryDocument
}
