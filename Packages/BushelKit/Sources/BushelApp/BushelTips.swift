//
// BushelTips.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(TipKit)
  import Foundation
  import TipKit

  @available(*, unavailable, message: "Not quite ready yet.")
  enum BushelTips {
    private static var configured = false
    static func configure() throws {
      if configured {
        return
      }
      try Tips.resetDatastore()
      try Tips.configure()
      print("tip configured")

      configured = true
    }
  }
#endif