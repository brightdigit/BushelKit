//
//  RecordedImage.swift
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

public struct RecordedImage: Sendable, Codable {
  public enum Field: Sendable {
    case imageUUID
    case size
    case fileSize
  }

  public let imageUUID: UUID
  public let name: String
  public let notes: String
  public let createdAt: Date
  public let resolution: RecordedResolution
  public let fileSize: UInt64
  public let fileExtension: String
  
  public let configuration: CaptureImageConfiguration

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
  
  public init(initial: RecordedImage, name: String, notes: String) {
    self.init(imageUUID: initial.imageUUID, name: name, notes: notes, createdAt: initial.createdAt, resolution: initial.resolution, fileSize: initial.fileSize, fileExtension: initial.fileExtension, configuration: initial.configuration)
  }
}
