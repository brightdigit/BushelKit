//
//  InitializablePackage.swift
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

public import Foundation
public import RadiantDocs
import BushelUtilities

extension InitializablePackage {
  /// Creates a new instance of the `InitializablePackage` at the specified file URL.
  ///
  /// - Parameter fileURL: The URL where the package should be created.
  /// - Throws: Any errors that occur during the creation
  /// of the directory or the writing of the metadata JSON file.
  /// - Returns: The newly created instance of the `InitializablePackage`.
  @discardableResult
  public static func createAt(_ fileURL: URL) throws -> Self {
    let library = self.init()
    try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: false)
    let metadataJSONPath = fileURL.appendingPathComponent(self.configurationFileWrapperKey)
    let data = try JSON.encoder.encode(library)
    try data.write(to: metadataJSONPath)
    return library
  }
}