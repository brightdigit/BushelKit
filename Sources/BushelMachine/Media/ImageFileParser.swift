//
//  ImageFileParser.swift
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

public import Foundation

/// A struct responsible for parsing information from an image file.
public struct ImageFileParser: RecordedImageParser {
  /// A closure that retrieves the size of an image from a given URL.
  private let cgSizeFromURL: (URL) -> CGSize?

  /// The file manager used for file and directory operations.
  private let fileManager: FileManager

  /// Initializes a new instance of `ImageFileParser`.
  ///
  /// - Parameters:
  ///   - fileManager: The file manager to use for file and directory operations.
  ///   - cgSizeFromURL: A closure that retrieves the size of an image from a given URL.
  public init(fileManager: FileManager, cgSizeFromURL: @escaping (URL) -> CGSize?) {
    self.cgSizeFromURL = cgSizeFromURL
    self.fileManager = fileManager
  }

  private static func imageDestinationURL(
    withID imageUUID: UUID, withFileType fileType: ImageFileType, atDirectory directoryURL: URL
  ) -> URL {
    #if canImport(UniformTypeIdentifiers)
      return
        directoryURL
        .appendingPathComponent(imageUUID.uuidString)
        .appendingPathExtension(for: .init(imageType: fileType))
    #else
      return
        directoryURL
        .appendingPathComponent(imageUUID.uuidString)
        .appendingPathExtension(fileType.fileExtension)
    #endif
  }

  private func fileSizeOfURL(_ url: URL) throws -> UInt64? {
    let path: String
    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
      path = url.path()
    } else {
      path = url.path
    }
    let fileAttributes = try fileManager.attributesOfItem(atPath: path)
    return fileAttributes[.size] as? UInt64
  }

  /// Retrieves information about an image and moves the image file to a specified directory.
  ///
  /// - Parameters:
  ///   - image: The image to retrieve information about.
  ///   - directoryURL: The URL of the directory to move the image file to.
  /// - Returns: A `RecordedImage` instance containing the retrieved information.
  /// - Throws: `RecordedImageError` if there are any issues retrieving or moving the image file.
  public func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL)
    async throws(RecordedImageError) -> RecordedImage
  {
    let url = image.url
    guard let imageUUID = UUID(uuidString: url.deletingPathExtension().lastPathComponent) else {
      throw .missingField(.imageUUID)
    }
    let fileSize: UInt64?
    do {
      fileSize = try self.fileSizeOfURL(url)
    } catch {
      throw .innerError(error)
    }

    guard let fileSize else {
      throw .missingField(.fileSize)
    }

    guard let size = cgSizeFromURL(url) else {
      throw .missingField(.size)
    }

    let destinationURL = Self.imageDestinationURL(
      withID: imageUUID,
      withFileType: image.configuration.fileType,
      atDirectory: directoryURL
    )

    do {
      try self.fileManager.createEmptyDirectory(
        at: directoryURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try self.fileManager.moveItem(at: image.url, to: destinationURL)
    } catch {
      throw .innerError(error)
    }

    return .init(
      imageUUID: imageUUID,
      name: "",
      notes: "",
      createdAt: Date(),
      size: size,
      fileSize: fileSize,
      fileExtension: url.pathExtension,
      configuration: image.configuration
    )
  }
}
