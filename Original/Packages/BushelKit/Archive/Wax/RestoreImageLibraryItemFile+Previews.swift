//
// RestoreImageLibraryItemFile.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension RestoreImageLibraryItemFile {
  static let preview: [RestoreImageLibraryItemFile] = [
    .init(
      id: .init(),
      metadata: .Previews.venturaBeta3,
      name: "Ventura Beta 3",
      fileAccessor: URLAccessor(url: URL.randomFile())
    ),
    .init(
      id: .init(),
      metadata: .Previews.monterey,
      name: "Montery 12.4",
      fileAccessor: URLAccessor(url: URL.randomFile())
    )
  ]
}
