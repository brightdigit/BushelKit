//
//  CaptureVideoCodec.swift
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

public enum CaptureVideoCodec: String, Sendable, Codable {
  case h264
}

extension CaptureVideoCodec {
  /// Returns a user-friendly display name for the codec
  public var displayName: String {
    switch self {
    case .h264:
      "H.264"
    }
  }

  /// Returns a more detailed description of the codec
  public var description: String {
    switch self {
    case .h264:
      "H.264/AVC - High efficiency video compression standard"
    }
  }

  /// Returns technical details about the codec
  public var technicalDescription: String {
    switch self {
    case .h264:
      """
      Name: H.264/MPEG-4 AVC
      Type: Lossy compression
      Usage: Standard video compression for streaming and storage
      Features: High compression efficiency, widely supported
      """
    }
  }

  /// Returns common alternative names for the codec
  public var alternativeNames: [String] {
    switch self {
    case .h264:
      ["AVC", "MPEG-4 Part 10", "Advanced Video Coding"]
    }
  }
}
