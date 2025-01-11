//
//  SPPrintersSoftwareDataType.swift
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

/// Represents a data type for printers' software.
public struct SPPrintersSoftwareDataType: Codable, Equatable, Sendable {
  /// The coding keys for the data type.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case imageCaptureSupport = "image capture support"
    case extensions
  }

  /// The name of the data type.
  public let name: String

  /// The image capture support for the data type.
  public let imageCaptureSupport: [Extension]?

  /// The extensions for the data type.
  public let extensions: [Extension]?

  /// Initializes a new instance of `SPPrintersSoftwareDataType`.
  ///
  /// - Parameters:
  ///   - name: The name of the data type.
  ///   - imageCaptureSupport: The image capture support for the data type.
  ///   - extensions: The extensions for the data type.
  public init(
    name: String,
    imageCaptureSupport: [Extension]?,
    extensions: [Extension]?
  ) {
    self.name = name
    self.imageCaptureSupport = imageCaptureSupport
    self.extensions = extensions
  }
}
