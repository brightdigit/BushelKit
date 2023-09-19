//
// Label.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public extension Label where Title == Text, Icon == Image {
    init(_ id: LocalizedStringID, systemImage: String) {
      self.init(id: id, systemImage: systemImage)
    }

    init(id: LocalizedID, systemImage: String) {
      self.init(
        title: { Text(id) },
        icon: { Image(systemName: systemImage) }
      )
    }
  }
#endif
