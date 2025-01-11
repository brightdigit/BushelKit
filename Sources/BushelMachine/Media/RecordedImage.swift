//
//  RecordedImage.swift
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

/// A struct representing a recorded image.
public struct RecordedImage: Sendable, Codable {
  /// An enum representing the fields of a `RecordedImage`.
  public enum Field: Sendable {
    case imageUUID
    case size
    case fileSize
  }

  /// The unique identifier for the image.
  public let imageUUID: UUID
  /// The name of the image.
  public let name: String
  /// The notes associated with the image.
  public let notes: String
  /// The date and time when the image was created.
  public let createdAt: Date
  /// The resolution of the image.
  public let resolution: RecordedResolution
  /// The size of the image file in bytes.
  public let fileSize: UInt64
  /// The file extension of the image.
  public let fileExtension: String

  /// The configuration used to capture the image.
  public let configuration: CaptureImageConfiguration

  /// Initializes a `RecordedImage` instance with the provided parameters.
  /// - Parameters:
  ///   - imageUUID: The unique identifier for the image.
  ///   - name: The name of the image.
  ///   - notes: The notes associated with the image.
  ///   - createdAt: The date and time when the image was created.
  ///   - resolution: The resolution of the image.
  ///   - fileSize: The size of the image file in bytes.
  ///   - fileExtension: The file extension of the image.
  ///   - configuration: The configuration used to capture the image.
  public init(
    imageUUID: UUID,
    name: String,
    notes: String,
    createdAt: Date,
    resolution: RecordedResolution,
    fileSize: UInt64,
    fileExtension: String,
    configuration: CaptureImageConfiguration
  ) {
    self.imageUUID = imageUUID
    self.name = name
    self.notes = notes
    self.createdAt = createdAt
    self.resolution = resolution
    self.fileSize = fileSize
    self.fileExtension = fileExtension
    self.configuration = configuration
  }
}

extension RecordedImage {
  /// Initializes a `RecordedImage` instance with the provided parameters.
  /// - Parameters:
  ///   - imageUUID: The unique identifier for the image.
  ///   - name: The name of the image.
  ///   - notes: The notes associated with the image.
  ///   - createdAt: The date and time when the image was created.
  ///   - size: The size of the image.
  ///   - fileSize: The size of the image file in bytes.
  ///   - fileExtension: The file extension of the image.
  ///   - configuration: The configuration used to capture the image.
  public init(
    imageUUID: UUID,
    name: String,
    notes: String,
    createdAt: Date,
    size: CGSize,
    fileSize: UInt64,
    fileExtension: String,
    configuration: CaptureImageConfiguration
  ) {
    self.init(
      imageUUID: imageUUID,
      name: name,
      notes: notes,
      createdAt: createdAt,
      resolution: .init(cgSize: size),
      fileSize: fileSize,
      fileExtension: fileExtension,
      configuration: configuration
    )
  }

  /// Initializes a `RecordedImage` instance
  /// based on an existing `RecordedImage` instance,
  /// but with a new name and notes.
  /// - Parameters:
  ///   - initial: The existing `RecordedImage` instance to base the new instance on.
  ///   - name: The new name for the image.
  ///   - notes: The new notes for the image.
  public init(initial: RecordedImage, name: String, notes: String) {
    self.init(
      imageUUID: initial.imageUUID,
      name: name,
      notes: notes,
      createdAt: initial.createdAt,
      resolution: initial.resolution,
      fileSize: initial.fileSize,
      fileExtension: initial.fileExtension,
      configuration: initial.configuration
    )
  }
}
