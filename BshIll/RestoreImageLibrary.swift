

struct RestoreImageLibrary : Codable {
  internal init(items: [RestoreImageLibraryItemFile] = .init()) {
    self.items = items
  }
  
  var items : [RestoreImageLibraryItemFile]
}
