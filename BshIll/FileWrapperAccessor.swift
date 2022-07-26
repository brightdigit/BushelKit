import SwiftUI


struct FileWrapperAccessor : FileAccessor {
  
  func getData() -> Data? {
    self.fileWrapper.regularFileContents
  }
  
  func getURL() throws -> URL {
    if let url = url {
      return url
    }
    let tempFileURL = FileManager.default.createTemporaryFile(for: .iTunesIPSW)
    try self.fileWrapper.write(to: tempFileURL, originalContentsURL: nil)
    return tempFileURL
  }
  
  func updatingWithURL(_ url: URL, sha256: SHA256) -> FileAccessor {
    return FileWrapperAccessor(fileWrapper: self.fileWrapper, url: url, sha256: sha256)
  }
  
  let fileWrapper : FileWrapper
  let url : URL?
  let sha256: SHA256?
}
