//
// RestoreImageDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct RestoreImageDocument: FileDocument {
  let fileWrapper: FileWrapper

  static let readableContentTypes = UTType.ipswTypes

  init(configuration: ReadConfiguration) throws {
    fileWrapper = configuration.file
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    guard let fileWrapper = configuration.existingFile else {
      throw DocumentError.undefinedType("Missing file for restore image.", configuration.existingFile)
    }

    return fileWrapper
  }
}
