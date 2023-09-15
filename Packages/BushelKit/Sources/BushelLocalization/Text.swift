//
// Text.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public extension Text {
    init(_ source: LocalizedStringID) {
      self.init(source.key, bundle: .module)
    }

    init(_ strings: LocalizedText..., joinedBy separator: String = " ") {
      let text = strings.map { $0.asString() }.joined(separator: separator)
      self.init(text)
    }

    init(localizedUsingID id: LocalizedStringID, arguments: CVarArg...) {
      self.init(
        String(localizedUsingID: id, arguments: arguments)
      )
    }
  }

  public extension Label where Title == Text, Icon == Image {
    init(_ id: LocalizedStringID, systemImage: String) {
      self.init(id.key, systemImage: systemImage)
    }
  }
#endif
