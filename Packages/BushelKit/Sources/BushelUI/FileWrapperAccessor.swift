//
// FileWrapperAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import Foundation

struct FileWrapperAccessor: FileAccessor {
  func getData() -> Data? {
    fileWrapper.regularFileContents
  }

  func getURL(createIfNotExists: Bool) throws -> URL {
    if let url = url {
      return url
    }
    guard createIfNotExists else {
      throw MachineError.undefinedType("url doesn't exists", self)
    }
    let tempFileURL = FileManager.default.createTemporaryFile(for: .iTunesIPSW)
    try fileWrapper.write(to: tempFileURL, originalContentsURL: nil)
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
