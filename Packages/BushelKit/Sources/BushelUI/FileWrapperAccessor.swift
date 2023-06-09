//
// FileWrapperAccessor.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

#if !os(Linux)

  struct FileWrapperAccessor: FileAccessor {
//    func getData() -> Data? {
//      fileWrapper.regularFileContents
//    }

    func getURL(createIfNotExists: Bool) throws -> URL {
      if let url = url {
        return url
      }
      guard createIfNotExists else {
        throw ManagerError.undefinedType("url doesn't exists", self)
      }
      #if canImport(UniformTypeIdentifiers)
        let tempFileURL = FileManager.default.createTemporaryFile(for: .iTunesIPSW)
        try fileWrapper.write(to: tempFileURL, originalContentsURL: nil)
      #else
        let tempFileURL = FileManager.default.createTemporaryFile(withPathExtension: "ipsw")
        try fileWrapper.write(toFile: tempFileURL.path, atomically: true, updateFilenames: false)
      #endif
      return tempFileURL
    }

    func updatingWithURL(_ url: URL) -> FileAccessor {
      if self.url != url {
        return FileWrapperAccessor(fileWrapper: fileWrapper, url: url)
      } else {
        return self
      }
    }

    let fileWrapper: FileWrapper

    let url: URL?
  }

  extension FileWrapperAccessor {
    init(fileWrapper: FileWrapper, directoryURL: URL?, name: String) {
      let fileName = fileWrapper.filename ?? name
      self.init(
        fileWrapper: fileWrapper,
        url: directoryURL?.appendingPathComponent(fileName)
      )
    }
  }
#endif
