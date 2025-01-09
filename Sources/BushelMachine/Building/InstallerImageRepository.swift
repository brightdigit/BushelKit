//
//  InstallerImageRepository.swift
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
public import Foundation

/// A protocol that defines an image repository for installer images.
public protocol InstallerImageRepository: Sendable {
  /// The error type associated with this repository.
  typealias Error = InstallerImageError

  /// Retrieves a list of installer images.
  ///
  /// - Parameter labelProvider: A closure that provides metadata labels for the images.
  /// - Returns: An array of `InstallerImage` objects.
  func images(
    _ labelProvider: @escaping MetadataLabelProvider
  ) async throws -> [any InstallerImage]

  /// Retrieves an installer image with the specified ID.
  ///
  /// - Parameters:
  ///   - id: The unique identifier of the image.
  ///   - library: The library identifier, if applicable.
  ///   - labelProvider: A closure that provides metadata labels for the image.
  /// - Returns: The `InstallerImage` object, or `nil` if not found.
  func image(
    withID id: UUID,
    library: LibraryIdentifier?,
    _ labelProvider: @escaping MetadataLabelProvider
  ) async throws -> (any InstallerImage)?

  /// Removes an installer image from the repository.
  ///
  /// - Parameter image: The `InstallerImage` object to remove.
  /// - Returns: A `RemoveImageFailure` value if the removal failed, or `nil` if successful.
  @discardableResult
  func removeImage(_ image: any InstallerImage) async throws -> RemoveImageFailure?
}
