import Foundation



protocol FileAccessor {
  var sha256 : SHA256? { get }
  func getData () -> Data?
  func getURL() throws -> URL
  func updatingWithURL(_ url: URL, sha256: SHA256) -> FileAccessor
  //func writeTo(_ url: URL) throws
  
}
