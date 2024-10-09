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
  public static let defaultHeight = 1_080

  public let format: CaptureVideoPixelFormat
  public let fileType: CaptureVideoFileType
  public let codec: CaptureVideoCodec
  public let height: Int
  public let watermark: Watermark?

  private init(
    format: CaptureVideoPixelFormat = .bgra32,
    fileType: CaptureVideoFileType = .quickTimeMovie,
    codec: CaptureVideoCodec = .h264,
    height: Int = defaultHeight,
    watermark: Watermark?
  ) {
    self.format = format
    self.fileType = fileType
    self.codec = codec
    self.height = height
    self.watermark = watermark
  }

  public init(watermark: Watermark?) {
    self.init(watermark: watermark)
  }
}
