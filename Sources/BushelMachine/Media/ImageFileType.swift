//
//  ImageFileType.swift
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

/// Represents an image file type.
public enum ImageFileType: String, Sendable, Codable {
  /// Represents a JPEG image file.
  case jpeg
}

#if canImport(UniformTypeIdentifiers)
  public import UniformTypeIdentifiers

  extension UTType {
    /// Initializes a new `UTType` instance with the provided `ImageFileType`.
    /// - Parameter imageType: The `ImageFileType` to initialize the `UTType` with.
    public init(imageType: ImageFileType) {
      switch imageType {
      case .jpeg:
        self = .jpeg
      }
    }
  }
#else
  extension ImageFileType {
    /// The file extension associated with the `ImageFileType`.
    public var fileExtension: String {
      switch self {
      case .jpeg:
        "jpg"
      }
    }
  }
#endif
