//
//  ScreenSettings.swift
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

internal import Foundation

/// A struct that represents screen settings.
public struct ScreenSettings: CustomDebugStringConvertible {
  /// A boolean value indicating whether the screen captures system keys.
  public var capturesSystemKeys = false

  /// A boolean value indicating whether the display is automatically reconfigured.
  public var automaticallyReconfiguresDisplay = false

  /// A string that provides a textual representation of the screen settings for debugging purposes.
  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "capturesSystemKeys : \(self.capturesSystemKeys); automaticallyReconfiguresDisplay : \(self.automaticallyReconfiguresDisplay)"
  }

  /// Initializes a new instance of `ScreenSettings`.
  ///
  /// - Parameters:
  ///   - capturesSystemKeys: A boolean value indicating whether the screen captures system keys.
  ///   - automaticallyReconfiguresDisplay: A boolean value indicating whether the display
  ///   is automatically reconfigured.
  public init(capturesSystemKeys: Bool = false, automaticallyReconfiguresDisplay: Bool = false) {
    self.capturesSystemKeys = capturesSystemKeys
    self.automaticallyReconfiguresDisplay = automaticallyReconfiguresDisplay
  }
}
