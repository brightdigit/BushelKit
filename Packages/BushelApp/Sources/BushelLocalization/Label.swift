//
// Label.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Label where Title == Text, Icon == Image {
    public init(_ id: LocalizedStringID, systemImage: String) {
      self.init(id: id, systemImage: systemImage)
    }

    public init(id: any LocalizedID, systemImage: String) {
      self.init(
        title: { Text(id) },
        icon: { Image(systemName: systemImage) }
      )
    }
  }
#endif
