//
//  SpdevtoolsApps.swift
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

public import Foundation

/// A struct that represents the Spdevtools apps.
public struct SpdevtoolsApps: Codable, Equatable, Sendable {
  /// The coding keys for the Spdevtools apps.
  public enum CodingKeys: String, CodingKey {
    case spinstrumentsApp = "spinstruments_app"
    case spxcodeApp = "spxcode_app"
  }

  /// The URL of the Spinstruments app.
  public let spinstrumentsApp: String
  /// The URL of the SPXCode app.
  public let spxcodeApp: String

  /// Initializes a new instance of `SpdevtoolsApps`.
  ///
  /// - Parameters:
  ///   - spinstrumentsApp: The URL of the Spinstruments app.
  ///   - spxcodeApp: The URL of the SPXCode app.
  public init(
    spinstrumentsApp: String,
    spxcodeApp: String
  ) {
    self.spinstrumentsApp = spinstrumentsApp
    self.spxcodeApp = spxcodeApp
  }
}
