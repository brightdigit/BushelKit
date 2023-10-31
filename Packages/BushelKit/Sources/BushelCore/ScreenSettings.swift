//
// ScreenSettings.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct ScreenSettings: CustomDebugStringConvertible {
  public var capturesSystemKeys: Bool = false
  public var automaticallyReconfiguresDisplay: Bool = false

  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "capturesSystemKeys : \(capturesSystemKeys); automaticallyReconfiguresDisplay : \(automaticallyReconfiguresDisplay)"
  }

  public init(capturesSystemKeys: Bool = false, automaticallyReconfiguresDisplay: Bool = false) {
    self.capturesSystemKeys = capturesSystemKeys
    self.automaticallyReconfiguresDisplay = automaticallyReconfiguresDisplay
  }
}
