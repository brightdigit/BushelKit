//
// Text.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Text {
    init(_ type: LocalizedStringID) {
      self.init(type.key, bundle: .module)
    }

    init(_ strings: LocalizedText..., joinedBy separator: String = " ") {
      let text = strings.map { $0.asString() }.joined(separator: separator)
      self.init(text)
    }
  }
#endif
