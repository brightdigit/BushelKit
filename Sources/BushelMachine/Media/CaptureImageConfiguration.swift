//
//  CaptureImageConfiguration.swift
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

/// Represents a configuration for capturing an image.
/// Conforms to the `Sendable`, `Codable`, and `CustomStringConvertible` protocols.
public struct CaptureImageConfiguration: Sendable, Codable, CustomStringConvertible {
  /// A description of the configuration, including the file type and compression level.
  public var description: String {
    "\(self.fileType.rawValue.uppercased()) (\(self.compression.roundToNearest(value: 0.01)))"
  }

  /// The file type of the captured image.
  public let fileType: ImageFileType

  /// The compression level of the captured image, between 0 and 1.
  public let compression: Double

  /// An optional watermark to be applied to the captured image.
  public let watermark: Watermark?

  /// Initializes a new `CaptureImageConfiguration` instance with the specified parameters.
  ///
  /// - Parameters:
  ///   - fileType: The file type of the captured image.
  ///   - compression: The compression level of the captured image, between 0 and 1.
  ///   - watermark: An optional watermark to be applied to the captured image.
  private init(fileType: ImageFileType, compression: Double, watermark: Watermark?) {
    self.fileType = fileType
    self.compression = compression
    self.watermark = watermark
  }

  /// Initializes a new `CaptureImageConfiguration` instance
  /// with a default file type, compression level, and an optional watermark.
  ///
  /// - Parameter watermark: An optional watermark to be applied to the captured image.
  public init(watermark: Watermark?) {
    self.init(fileType: .jpeg, compression: 0.8, watermark: watermark)
  }
}
