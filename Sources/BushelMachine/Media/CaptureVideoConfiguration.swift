//
//  CaptureVideoConfiguration.swift
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

public struct CaptureVideoConfiguration: Sendable, Codable {
  private enum Defaults {
    fileprivate static let format: CaptureVideoPixelFormat = .bgra32
    fileprivate static let fileType: CaptureVideoFileType = .quickTimeMovie
    fileprivate static let codec: CaptureVideoCodec = .h264
    fileprivate static let height: Int = 1_080
  }

  /// The pixel format of the captured video.
  public let format: CaptureVideoPixelFormat

  /// The file type of the captured video.
  public let fileType: CaptureVideoFileType

  /// The video codec used for the captured video.
  public let codec: CaptureVideoCodec

  /// The height of the captured video in pixels.
  public let height: Int

  /// An optional watermark to be applied to the captured video.
  public let watermark: Watermark?

  private init(
    format: CaptureVideoPixelFormat,
    fileType: CaptureVideoFileType,
    codec: CaptureVideoCodec,
    height: Int,
    watermark: Watermark?
  ) {
    self.format = format
    self.fileType = fileType
    self.codec = codec
    self.height = height
    self.watermark = watermark
  }

  /// Initializes a `CaptureVideoConfiguration` with the default values and an optional watermark.
  ///
  /// - Parameter watermark: An optional watermark to be applied to the captured video.
  public init(watermark: Watermark?) {
    self.init(
      format: Defaults.format,
      fileType: Defaults.fileType,
      codec: Defaults.codec,
      height: Defaults.height,
      watermark: watermark
    )
  }
}

extension CaptureVideoConfiguration {
  /// Returns a concise, user-friendly summary of the video configuration.
  public var summary: String {
    // swiftlint:disable:next line_length
    "Video: \(self.codec.displayName), Format: \(self.format.description), File: \(self.fileType.displayName)"
  }

  /// Returns a detailed, technical description of the configuration.
  public var description: String {
    """
    Video Configuration:
    • Codec: \(self.codec.description)
    • Pixel Format: \(self.format.description)
    • File Type: \(self.fileType.description)
    """
  }

  /// Returns comprehensive technical details of the configuration.
  public var technicalDescription: String {
    """
    Video Configuration Details
    -------------------------
    Codec:
    \(self.codec.technicalDescription.split(separator: "\n").map { "  \($0)" }.joined(separator: "\n"))

    Pixel Format:
    \(self.format.technicalDescription.split(separator: "\n").map { "  \($0)" }.joined(separator: "\n"))

    File Container:
    • Type: \(self.fileType.displayName)
    • Extension: .\(self.fileType.fileExtension)
    • MIME Type: \(self.fileType.mimeType)
    """
  }

  /// Returns a short description suitable for UI labels.
  public var shortDescription: String {
    "\(self.codec.displayName) \(self.format.rawValue) \(self.fileType.fileExtension.uppercased())"
  }
}
