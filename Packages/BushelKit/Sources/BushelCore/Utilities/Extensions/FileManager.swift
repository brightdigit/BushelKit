//
//  FileManager.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation

#if os(Linux)
  public typealias FileSize = Int
#else
  public typealias FileSize = Int64
#endif

extension FileManager {
  public struct CreationError: Error {
    public enum Source {
      case open
      case ftruncate
      case close
    }

    public let code: Int
    public let source: Source
  }

  public func createFile(atPath path: String, withSize size: FileSize) throws {
    createFile(atPath: path, contents: nil)
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

  public func directoryExists(at url: URL) -> DirectoryExists {
    var isDirectory: ObjCBool = false
    let fileExists = FileManager.default.fileExists(
      atPath: url.path,
      isDirectory: &isDirectory
    )

    return .init(fileExists: fileExists, isDirectory: isDirectory.boolValue)
  }

  public func relationship(
    of directory: FileManager.SearchPathDirectory,
    toItemAt url: URL,
    in domainMask: FileManager.SearchPathDomainMask = .allDomainsMask
  ) throws -> URLRelationship {
    var relationship: URLRelationship = .other
    try self.getRelationship(&relationship, of: directory, in: domainMask, toItemAt: url)
    return relationship
  }

  @discardableResult
  public func createEmptyDirectory(
    at url: URL,
    withIntermediateDirectories createIntermediates: Bool,
    deleteExistingFile: Bool,
    attributes: [FileAttributeKey: Any]? = nil
  ) throws -> DirectoryExists {
    let directoryExistsStatus = self.directoryExists(at: url)

    #warning("logging-note: we could log each case for better debugging")
    switch directoryExistsStatus {
    case .directoryExists:
      break

    case .fileExists:
      if deleteExistingFile {
        try FileManager.default.removeItem(at: url)
      }
      fallthrough

    case .notExists:
      try FileManager.default.createDirectory(
        at: url,
        withIntermediateDirectories: createIntermediates,
        attributes: attributes
      )
    }

    return directoryExistsStatus
  }

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

  public func dataDictionary(
    directoryAt directoryURL: URL
  ) throws -> [String: Data] {
    let keys: Set<URLResourceKey> = Set([.isDirectoryKey, .isRegularFileKey])
    guard let enumerator = self.enumerator(
      at: directoryURL,
      includingPropertiesForKeys: Array(keys)
    ) else {
      throw .fileNotFound(at: directoryURL)
    }

    #warning("logging-note: descriptive error/logging here might help some other developer in debugging")
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

extension Error where Self == NSError {
  internal static func fileNotFound(at url: URL) -> NSError {
    NSError(
      domain: NSCocoaErrorDomain,
      code: NSFileNoSuchFileError,
      userInfo: [
        NSFilePathErrorKey: url.path,
        NSUnderlyingErrorKey: POSIXError(.ENOENT)
      ]
    )
  }
}
