//
// Previews.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
extension RestoreImage {
  enum Previews {
    static func usingMetadata(_ metadata: ImageMetadata) -> RestoreImage {
      .init(metadata: metadata, installer: { MockInstaller() })
    }
  }
}
