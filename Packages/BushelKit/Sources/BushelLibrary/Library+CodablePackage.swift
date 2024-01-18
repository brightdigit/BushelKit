//
// Library+CodablePackage.swift
// Copyright (c) 2024 BrightDigit.
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
    URL.bushel.paths.restoreLibraryJSONFileName
  }

  public static var readableContentTypes: [FileType] {
    [.restoreImageLibrary]
  }

  public init() {
    self.init(items: [])
  }
}
