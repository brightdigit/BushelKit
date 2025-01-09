//
//  CaptureVideoFileType.swift
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

public enum CaptureVideoFileType: String, Sendable, Codable {
  case quickTimeMovie
}

#if canImport(UniformTypeIdentifiers)
  public import UniformTypeIdentifiers

  extension UTType {
    /// Initializes a new `UTType` instance with the provided `CaptureVideoFileType`.
    /// - Parameter videoType: The `CaptureVideoFileType` to use for the initialization.
    public init(videoType: CaptureVideoFileType) {
      switch videoType {
      case .quickTimeMovie:
        self = .quickTimeMovie
      }
    }
  }
#endif

extension CaptureVideoFileType {
  /// Returns a user-friendly display name for the file type.
  public var displayName: String {
    switch self {
    case .quickTimeMovie:
      "QuickTime Movie"
    }
  }

  /// Returns the common file extension for this file type.
  public var fileExtension: String {
    switch self {
    case .quickTimeMovie:
      "mov"
    }
  }

  /// Returns a more detailed description of the file type.
  public var description: String {
    switch self {
    case .quickTimeMovie:
      "QuickTime Movie (.mov) - A multimedia container file format developed by Apple"
    }
  }

  /// Returns the MIME type for the file format.
  public var mimeType: String {
    switch self {
    case .quickTimeMovie:
      "video/quicktime"
    }
  }
}
