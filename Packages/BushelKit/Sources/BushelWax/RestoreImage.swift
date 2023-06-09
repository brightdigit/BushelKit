//
// RestoreImage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation
public extension RestoreImage {
  enum Previews {
    public static func usingMetadata(_ metadata: ImageMetadata) -> RestoreImage {
      .init(
        metadata: metadata,
        location: .file(URLAccessor(url: .randomFile()))
      )
    }
  }
}
