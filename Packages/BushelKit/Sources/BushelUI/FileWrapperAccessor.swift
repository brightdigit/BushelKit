//
// FileWrapperAccessor.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import Foundation

struct FileWrapperAccessor: FileAccessor {
  func getData() -> Data? {
    fileWrapper.regularFileContents
  }

  func getURL() throws -> URL {
    if let url = url {
      return url
    }
    let tempFileURL = FileManager.default.createTemporaryFile(for: .iTunesIPSW)
    try fileWrapper.write(to: tempFileURL, originalContentsURL: nil)
    return tempFileURL
  }

  func updatingWithURL(_ url: URL, sha256: SHA256) -> FileAccessor {
    FileWrapperAccessor(fileWrapper: fileWrapper, url: url, sha256: sha256)
  }

  let fileWrapper: FileWrapper
  let url: URL?
  let sha256: SHA256?
}
