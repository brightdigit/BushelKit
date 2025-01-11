//
//  SPUniversalAccessDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

/// A data type representing universal accessibility settings.
public struct SPUniversalAccessDataType: Codable, Equatable, Sendable {
  /// Coding keys for the `SPUniversalAccessDataType` struct.
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

  /// The name of the universal access data type.
  public let name: String
  /// The contrast setting.
  public let contrast: String
  /// The cursor magnification setting.
  public let cursorMag: String
  /// The display setting.
  public let display: String
  /// The flash screen setting.
  public let flashScreen: String
  /// The keyboard zoom setting.
  public let keyboardZoom: String
  /// The mouse keys setting.
  public let mouseKeys: String
  /// The scroll zoom setting.
  public let scrollZoom: String
  /// The slow keys setting.
  public let slowKeys: String
  /// The sticky keys setting.
  public let stickyKeys: String
  /// The voiceover setting.
  public let voiceover: String
  /// The zoom mode setting.
  public let zoomMode: String

  /// Initializes a new `SPUniversalAccessDataType` instance.
  ///
  /// - Parameters:
  ///   - name: The name of the universal access data type.
  ///   - contrast: The contrast setting.
  ///   - cursorMag: The cursor magnification setting.
  ///   - display: The display setting.
  ///   - flashScreen: The flash screen setting.
  ///   - keyboardZoom: The keyboard zoom setting.
  ///   - mouseKeys: The mouse keys setting.
  ///   - scrollZoom: The scroll zoom setting.
  ///   - slowKeys: The slow keys setting.
  ///   - stickyKeys: The sticky keys setting.
  ///   - voiceover: The voiceover setting.
  ///   - zoomMode: The zoom mode setting.
  public init(
    name: String,
    contrast: String,
    cursorMag: String,
    display: String,
    flashScreen: String,
    keyboardZoom: String,
    mouseKeys: String,
    scrollZoom: String,
    slowKeys: String,
    stickyKeys: String,
    voiceover: String,
    zoomMode: String
  ) {
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
