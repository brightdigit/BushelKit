//
//  CaptureVideoConfiguration.swift
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

public struct CaptureVideoConfiguration: Sendable, Codable {
  private enum Defaults {
    fileprivate static let format: CaptureVideoPixelFormat = .bgra32
    fileprivate static let fileType: CaptureVideoFileType = .quickTimeMovie
    fileprivate static let codec: CaptureVideoCodec = .h264
    fileprivate static let height: Int = 1_080
  }

  public let format: CaptureVideoPixelFormat
  public let fileType: CaptureVideoFileType
  public let codec: CaptureVideoCodec
  public let height: Int
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
  /// Returns a concise, user-friendly summary of the video configuration
  public var summary: String {
    "Video: \(codec.displayName), Format: \(format.description), File: \(fileType.displayName)"
  }

  /// Returns a detailed, technical description of the configuration
  public var description: String {
    """
    Video Configuration:
    • Codec: \(codec.description)
    • Pixel Format: \(format.description)
    • File Type: \(fileType.description)
    """
  }

  /// Returns comprehensive technical details of the configuration
  public var technicalDescription: String {
    """
    Video Configuration Details
    -------------------------
    Codec:
    \(codec.technicalDescription.split(separator: "\n").map { "  \($0)" }.joined(separator: "\n"))

    Pixel Format:
    \(format.technicalDescription.split(separator: "\n").map { "  \($0)" }.joined(separator: "\n"))

    File Container:
    • Type: \(fileType.displayName)
    • Extension: .\(fileType.fileExtension)
    • MIME Type: \(fileType.mimeType)
    """
  }

  /// Returns a short description suitable for UI labels
  public var shortDescription: String {
    "\(codec.displayName) \(format.rawValue) \(fileType.fileExtension.uppercased())"
  }
}
