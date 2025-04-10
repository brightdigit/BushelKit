//
//  Library+CodablePackage.swift
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

internal import BushelUtilities
public import Foundation
public import RadiantDocs
internal import RadiantKit

/// An extension to the `Library` type that conforms to the `InitializablePackage` protocol.
extension Library: InitializablePackage {
  /// The default `JSONDecoder` instance used for decoding `Library` objects.
  public static var decoder: JSONDecoder {
    JSON.decoder
  }

  /// The default `JSONEncoder` instance used for encoding `Library` objects.
  public static var encoder: JSONEncoder {
    JSON.encoder
  }

  /// The key used to identify the configuration file wrapper for the library.
  public static var configurationFileWrapperKey: String {
    URL.bushel.paths.restoreLibraryJSONFileName
  }

  /// The file types that are considered readable content for the library.
  public static var readableContentTypes: [FileType] {
    [.restoreImageLibrary]
  }

  /// Initializes a new `Library` instance with an empty array of items.
  public init() {
    self.init(items: [])
  }
}
