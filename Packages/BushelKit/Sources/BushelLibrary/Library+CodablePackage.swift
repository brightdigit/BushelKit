//
// Library+CodablePackage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

extension Library: InitializablePackage {
  public static var decoder: JSONDecoder {
    JSON.decoder
  }

  public static var encoder: JSONEncoder {
    JSON.encoder
  }

  public static var configurationFileWrapperKey: String {
    Paths.restoreLibraryJSONFileName
  }

  public static var readableContentTypes: [FileType] {
    [.restoreImageLibrary]
  }

  public init() {
    self.init(items: [])
  }
}