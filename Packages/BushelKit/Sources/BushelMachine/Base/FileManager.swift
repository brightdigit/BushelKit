//
// FileManager.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers
#endif

#if os(Linux)
  public typealias FileSize = Int
#else
  public typealias FileSize = Int64
#endif

public extension FileManager {
  func createFile(atPath path: String, withSize size: FileSize) throws {
    createFile(atPath: path, contents: nil)
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

  #if canImport(UniformTypeIdentifiers)
    // swiftlint:disable:next function_body_length
    func createTemporaryFile(for type: UTType) -> URL {
      let tempFile: URL
      //
      #if swift(>=5.7.1)
        if #available(macOS 13.0, *) {
          tempFile = self.temporaryDirectory
            .appending(path: UUID().uuidString)
            .appendingPathExtension(for: type)
        } else {
          tempFile = temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(for: type)
        }
      #else
        tempFile = temporaryDirectory
          .appendingPathComponent(UUID().uuidString)
          .appendingPathExtension(for: type)
      #endif
      return tempFile
    }
  #else
    func createTemporaryFile(withPathExtension pathExtension: String) -> URL {
      let tempFile: URL

      tempFile = temporaryDirectory
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension(pathExtension)

      return tempFile
    }
  #endif
}

public extension FileManager {
  func directoryExists(at url: URL) -> DirectoryExists {
    var isDirectory: ObjCBool = false
    let fileExists = FileManager.default.fileExists(
      atPath: url.path,
      isDirectory: &isDirectory
    )

    return .init(fileExists: fileExists, isDirectory: isDirectory.boolValue)
  }

  func copyRestoreImage(at sourceFileURL: URL, toLibraryAt sourceURL: URL, withName name: String) throws {
    let restoreImageDirURL = sourceURL.appendingPathComponent("Restore Images")
    let destinationFileURL = restoreImageDirURL.appendingPathComponent(name)

    try FileManager.default.createDirectory(
      at: restoreImageDirURL,
      withIntermediateDirectories: true
    )
    try FileManager.default.copyItem(at: sourceFileURL, to: destinationFileURL)
  }
}