//
//  CaptureVideoPixelFormat.swift
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

/// Represents a video pixel format.
public enum CaptureVideoPixelFormat: String, Sendable, Codable {
  /// 32-bit BGRA (Blue, Green, Red, Alpha) pixel format.
  case bgra32 = "32BGRA"
}

#if canImport(CoreVideo)
  public import CoreVideo

  extension CaptureVideoPixelFormat {
    /// Returns the OSType value for the pixel format.
    public var osType: OSType {
      switch self {
      case .bgra32:
        kCVPixelFormatType_32BGRA
      }
    }
  }
#endif

extension CaptureVideoPixelFormat {
  /// Returns a user-friendly description of the pixel format.
  public var description: String {
    switch self {
    case .bgra32:
      "32-bit BGRA (Blue, Green, Red, Alpha)"
    }
  }

  /// Returns detailed technical information about the pixel format.
  public var technicalDescription: String {
    switch self {
    case .bgra32:
      """
      Format: 32-bit BGRA
      Bits per pixel: 32
      Channel order: Blue, Green, Red, Alpha
      Alpha: Yes (8-bit)
      Memory layout: 8 bits per channel
      """
    }
  }

  /// Returns the number of bits per pixel.
  public var bitsPerPixel: Int {
    switch self {
    case .bgra32:
      32
    }
  }

  /// Returns whether the format includes an alpha channel.
  public var hasAlpha: Bool {
    switch self {
    case .bgra32:
      true
    }
  }
}
