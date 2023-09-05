//
// LibraryImageFile+Previews.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public extension LibraryImageFile {
  static let preview: [LibraryImageFile] = [
    .init(
      id: .init(),
      metadata: .Previews.venturaBeta3,
      name: "macOS Monterey 12.4.0"
    ),
    .init(
      id: .init(),
      metadata: .Previews.monterey,
      name: "macOS Ventura 13.0.0"
    ),
    .init(
      id: .init(),
      metadata: .Previews.monterey,
      name: "macOS Ventura 13.4.0"
    )
  ]
}
