//
//  ImageFileParser.swift
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

public struct ImageFileParser: RecordedImageParser {
  private let cgSizeFromURL: (URL) -> CGSize?
  private let fileManager: FileManager

  public init(fileManager: FileManager, cgSizeFromURL: @escaping (URL) -> CGSize?) {
    self.cgSizeFromURL = cgSizeFromURL
    self.fileManager = fileManager
  }

  public func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL)
    async throws(RecordedImageError) -> RecordedImage
  {
    let url = image.url
    guard let imageUUID = UUID(uuidString: url.deletingPathExtension().lastPathComponent) else {
      throw .missingField(.imageUUID)
    }
    let fileSize: UInt64?
    do {
      let fileAttributes = try fileManager.attributesOfItem(atPath: url.path())
      fileSize = fileAttributes[.size] as? UInt64
    } catch {
      throw .innerError(error)
    }

    guard let fileSize else {
      throw .missingField(.fileSize)
    }

    guard let size = cgSizeFromURL(url) else {
      throw .missingField(.size)
    }

    #if canImport(UniformTypeIdentifiers)
      let captureDestinationURL =
        directoryURL
        .appendingPathComponent(imageUUID.uuidString)
        .appendingPathExtension(for: .init(imageType: image.configuration.fileType))
    #else
      let captureDestinationURL =
        directoryURL
        .appendingPathComponent(imageUUID.uuidString)
        .appendingPathExtension(image.configuration.fileType.fileExtension)
    #endif

    do {
      try self.fileManager.createEmptyDirectory(
        at: directoryURL,
        withIntermediateDirectories: false,
        deleteExistingFile: false
      )
      try self.fileManager.moveItem(at: image.url, to: captureDestinationURL)
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
      configuration: image.configuration
    )
  }
}
