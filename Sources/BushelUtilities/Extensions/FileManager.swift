//
//  FileManager.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

#if os(Linux)
  public typealias FileSize = Int
#else
  public typealias FileSize = Int64
#endif
/// The file manager extension that provides additional functionality.
extension FileManager {
  /// Creates a file with the specified size at the given path.
  ///
  /// - Parameters:
  ///   - path: The path of the file to create.
  ///   - size: The size of the file to create.
  /// - Throws: `CreationError` if an error occurs during file creation.
  public func createFile(atPath path: String, withSize size: FileSize) throws {
    self.createFile(atPath: path, contents: nil)
    let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
    guard diskFd > 0 else {
      throw CreationError(code: Int(errno), source: .open)
    }

    // 64GB disk space.
    var result = ftruncate(diskFd, size)
    guard result == 0 else {
      throw CreationError(code: Int(result), source: .ftruncate)
    }

    result = close(diskFd)
    guard result == 0 else {
      throw CreationError(code: Int(result), source: .close)
    }
  }

  /// Checks the existence and type of a directory at the given URL.
  ///
  /// - Parameter url: The URL of the directory to check.
  /// - Returns: A `DirectoryExists` struct indicating the existence and type of the directory.
  public func directoryExists(at url: URL) -> DirectoryExists {
    var isDirectory: ObjCBool = false
    let fileExists = self.fileExists(
      atPath: url.path,
      isDirectory: &isDirectory
    )

    return .init(fileExists: fileExists, isDirectory: isDirectory.boolValue)
  }

  /// Determines the relationship of a directory to an item at the given URL.
  ///
  /// - Parameters:
  ///   - directory: The directory to check the relationship for.
  ///   - url: The URL of the item to check the relationship to.
  ///   - domainMask: The search path domain mask to use.
  /// - Returns: The `URLRelationship` of the directory to the item.
  /// - Throws: An error if the relationship cannot be determined.
  public func relationship(
    of directory: FileManager.SearchPathDirectory,
    toItemAt url: URL,
    in domainMask: FileManager.SearchPathDomainMask = .allDomainsMask
  ) throws -> URLRelationship {
    var relationship: URLRelationship = .other
    try self.getRelationship(&relationship, of: directory, in: domainMask, toItemAt: url)
    return relationship
  }

  /// Creates an empty directory at the specified URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the directory to create.
  ///   - createIntermediates: Whether to create intermediate directories if necessary.
  ///   - deleteExistingFile: Whether to delete an existing file at the URL.
  ///   - attributes: The file attributes to apply to the created directory.
  /// - Returns: A `DirectoryExists` struct indicating the existence and type of the directory.
  /// - Throws: An error if the directory cannot be created.
  @discardableResult
  public func createEmptyDirectory(
    at url: URL,
    withIntermediateDirectories createIntermediates: Bool,
    deleteExistingFile: Bool,
    attributes: [FileAttributeKey: Any]? = nil
  ) throws -> DirectoryExists {
    let directoryExistsStatus = self.directoryExists(at: url)

    switch directoryExistsStatus {
    case .directoryExists:
      break

    case .fileExists:
      if deleteExistingFile {
        try self.removeItem(at: url)
      }
      fallthrough

    case .notExists:
      try self.createDirectory(
        at: url,
        withIntermediateDirectories: createIntermediates,
        attributes: attributes
      )
    }

    return directoryExistsStatus
  }

  /// Writes a dictionary of data to a directory.
  ///
  /// - Parameters:
  ///   - dataDictionary: A dictionary of relative paths and data to write.
  ///   - directoryURL: The URL of the directory to write the data to.
  /// - Throws: An error if the data cannot be written.
  public func write(
    _ dataDictionary: [String: Data],
    to directoryURL: URL
  ) throws {
    for (relativePath, data) in dataDictionary {
      let fullURL = directoryURL.appendingPathComponent(relativePath)
      let parentURL = fullURL.deletingLastPathComponent()
      if self.directoryExists(at: parentURL) == .notExists {
        try self.createEmptyDirectory(
          at: parentURL,
          withIntermediateDirectories: true,
          deleteExistingFile: true
        )
      }
      try data.write(to: fullURL)
    }
  }

  /// Retrieves a dictionary of data from a directory.
  ///
  /// - Parameter directoryURL: The URL of the directory to retrieve data from.
  /// - Returns: A dictionary of relative paths and data.
  /// - Throws: An error if the data cannot be retrieved.
  public func dataDictionary(
    directoryAt directoryURL: URL
  ) throws -> [String: Data] {
    let keys: Set<URLResourceKey> = Set([.isDirectoryKey, .isRegularFileKey])
    guard
      let enumerator = self.enumerator(
        at: directoryURL,
        includingPropertiesForKeys: Array(keys)
      )
    else {
      throw .fileNotFound(at: directoryURL)
    }

    return try enumerator.reduce(into: [String: Data]()) { dictionary, item in
      guard let url = item as? URL else {
        return
      }
      guard try url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true else {
        return
      }
      assert(dictionary[url.lastPathComponent] == nil)
      dictionary[url.lastPathComponent] = try Data(contentsOf: url)
    }
  }

  /// Clears the saved application state.
  ///
  /// This method removes all directories with the name "Saved Application State"
  /// within the user's library directory.
  /// - Throws: An error if the saved application state directories cannot be removed.
  public func clearSavedApplicationState() throws {
    let savedApplicationStates = self.urls(for: .libraryDirectory, in: .userDomainMask)
      .map {
        $0.appendingPathComponent("Saved Application State")
      }
      .filter {
        self.directoryExists(at: $0) == .directoryExists
      }

    try savedApplicationStates.forEach(self.removeItem(at:))
  }
}
