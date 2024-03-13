//
// SPUniversalAccessDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPUniversalAccessDataType

public struct SPUniversalAccessDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case contrast
    case cursorMag = "cursor_mag"
    case display
    case flashScreen = "flash_screen"
    case keyboardZoom
    case mouseKeys = "mouse_keys"
    case scrollZoom
    case slowKeys = "slow_keys"
    case stickyKeys = "sticky_keys"
    case voiceover
    case zoomMode
  }

  public let name: String
  public let contrast: String
  public let cursorMag: String
  public let display: String
  public let flashScreen: String
  public let keyboardZoom: String
  public let mouseKeys: String
  public let scrollZoom: String
  public let slowKeys: String
  public let stickyKeys: String
  public let voiceover: String
  public let zoomMode: String

  // swiftlint:disable:next line_length
  public init(name: String, contrast: String, cursorMag: String, display: String, flashScreen: String, keyboardZoom: String, mouseKeys: String, scrollZoom: String, slowKeys: String, stickyKeys: String, voiceover: String, zoomMode: String) {
    self.name = name
    self.contrast = contrast
    self.cursorMag = cursorMag
    self.display = display
    self.flashScreen = flashScreen
    self.keyboardZoom = keyboardZoom
    self.mouseKeys = mouseKeys
    self.scrollZoom = scrollZoom
    self.slowKeys = slowKeys
    self.stickyKeys = stickyKeys
    self.voiceover = voiceover
    self.zoomMode = zoomMode
  }
}
