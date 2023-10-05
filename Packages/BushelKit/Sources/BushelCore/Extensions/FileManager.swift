//
// FileManager.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if os(Linux)
  public typealias FileSize = Int
#else
  public typealias FileSize = Int64
#endif

public extension FileManager {
  struct CreationError: Error {
    enum Source {
      case open
      case ftruncate
      case close
    }

    let code: Int
    let source: Source
  }

  func createFile(atPath path: String, withSize size: FileSize) throws {
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

  func directoryExists(at url: URL) -> DirectoryExists {
    var isDirectory: ObjCBool = false
    let fileExists = FileManager.default.fileExists(
      atPath: url.path,
      isDirectory: &isDirectory
    )

    return .init(fileExists: fileExists, isDirectory: isDirectory.boolValue)
  }

  func relationship(
    of directory: FileManager.SearchPathDirectory,
    toItemAt url: URL,
    in domainMask: FileManager.SearchPathDomainMask = .allDomainsMask
  ) throws -> URLRelationship {
    var relationship: URLRelationship = .other
    try self.getRelationship(&relationship, of: directory, in: domainMask, toItemAt: url)
    return relationship
  }

  @discardableResult
  func createEmptyDirectory(
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

  func write(
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

  func dataDictionary(
    directoryAt directoryURL: URL
  ) throws -> [String: Data] {
    let keys: Set<URLResourceKey> = Set([.isDirectoryKey, .isRegularFileKey])
    guard let enumerator = self.enumerator(
      at: directoryURL,
      includingPropertiesForKeys: Array(keys)
    ) else {
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
}

internal extension Error where Self == NSError {
  static func fileNotFound(at url: URL) -> NSError {
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
