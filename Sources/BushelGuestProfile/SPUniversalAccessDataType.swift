//
//  SPUniversalAccessDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

// MARK: - SPUniversalAccessDataType

public struct SPUniversalAccessDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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
