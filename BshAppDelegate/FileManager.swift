import Foundation

extension FileManager {
  func createFile (atPath path: String, withSize size: Int64) throws {
    self.createFile(atPath: path, contents: nil)
    let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
    guard diskFd > 0 else {
      throw FileCreationError(code: Int(errno), type: .open)
    }

    // 64GB disk space.
    var result = ftruncate(diskFd, size)
    
    guard result == 0 else {
      throw FileCreationError(code: Int(result), type: .ftruncate)
    }


    result = close(diskFd)
    guard result == 0 else {
      throw FileCreationError(code: Int(result), type: .close)
    }
  }
}
