//
//  InstallerImageError.swift
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

public import BushelFoundation
internal import BushelLogging
public import Foundation

/// Represents an error that occurred during the installation of an image.
public struct InstallerImageError: Error, Sendable {
  /// The different types of errors that can occur during image installation.
  public enum ErrorType: Sendable {
    /// The bookmark for the image is missing.
    case missingBookmark
    /// The URL for the image is not accessible.
    case accessDeniedURL(URL)
    /// The image was not found.
    case imageNotFound
  }

  /// The unique identifier of the image.
  public let imageID: UUID
  /// The identifier of the library associated with the image.
  public let libraryID: LibraryIdentifier?
  /// The type of error that occurred.
  public let type: ErrorType

  /// Initializes an `InstallerImageError` with the specified parameters.
  ///
  /// - Parameters:
  ///   - imageID: The unique identifier of the image.
  ///   - type: The type of error that occurred.
  ///   - libraryID: The identifier of the library associated with the image (optional).
  public init(
    imageID: UUID, type: InstallerImageError.ErrorType, libraryID: LibraryIdentifier? = nil
  ) {
    self.imageID = imageID
    self.libraryID = libraryID
    self.type = type
  }
}
