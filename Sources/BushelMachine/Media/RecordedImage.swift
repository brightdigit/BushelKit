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
  public enum InfoError: Error {
    case missingField(Field)
    case innerError(Error)
  }

  public let imageUUID: UUID
  public let name: String
  public let notes: String
  public let createdAt: Date
  public let width: Int
  public let height: Int
  public let fileSize: UInt64
  public let configuration: CaptureImageConfiguration

  public init(
    imageUUID: UUID,
    name: String,
    notes: String,
    createdAt: Date,
    width: Int,
    height: Int,
    fileSize: UInt64,
    configuration: CaptureImageConfiguration
  ) {
    self.imageUUID = imageUUID
    self.name = name
    self.notes = notes
    self.createdAt = createdAt
    self.width = width
    self.height = height
    self.fileSize = fileSize
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
    configuration: CaptureImageConfiguration
  ) {
    self.init(
      imageUUID: imageUUID,
      name: name,
      notes: notes,
      createdAt: createdAt,
      width: .init(size.width),
      height: .init(size.height),
      fileSize: fileSize,
      configuration: configuration
    )
  }
}
