//
// Previews.swift
// Copyright (c) 2022 BrightDigit.
//

// swiftlint:disable force_unwrapping line_length

import BushelMachine
import Foundation
extension RestoreImage {
  enum Previews {
    static func usingMetadata(_ metadata: ImageMetadata) -> RestoreImage {
      .init(
        metadata: metadata,
        location: .file(URLAccessor(url: URL(
          string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw"
        )!))
      )
    }
  }
}
