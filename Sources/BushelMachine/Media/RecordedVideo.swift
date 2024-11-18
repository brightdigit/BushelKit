//
//  RecordedVideo.swift
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

public struct RecordedVideo: Sendable, Codable {
  public enum Field: Sendable {
    case videoUUID
    case fileSize
    case naturalSize
  }

  public let videoUUID: UUID
  public let name: String
  public let createdAt: Date
  public let notes: String
  public let fileSize: UInt64
  public let resolution: RecordedResolution
  public let imageTimeInterval: Double
  public let duration: Double
  public let fileExtension: String
  public let configuration: CaptureVideoConfiguration

  public init(
    videoUUID: UUID,
    name: String,
    createdAt: Date,
    notes: String,
    fileSize: UInt64,
    resolution: RecordedResolution,
    duration: Double,
    imageTimeInterval: Double,
    fileExtension: String,
    configuration: CaptureVideoConfiguration
  ) {
    self.videoUUID = videoUUID
    self.name = name
    self.createdAt = createdAt
    self.notes = notes
    self.fileSize = fileSize
    self.resolution = resolution
    self.duration = duration
    self.fileExtension = fileExtension
    self.imageTimeInterval = imageTimeInterval
    self.configuration = configuration
  }

  public init(
    videoUUID: UUID,
    name: String,
    createdAt: Date,
    notes: String,
    fileSize: UInt64,
    size: CGSize,
    duration: Double,
    imageTimeInterval: Double,
    fileExtension: String,
    configuration: CaptureVideoConfiguration
  ) {
    self.init(
      videoUUID: videoUUID,
      name: name,
      createdAt: createdAt,
      notes: notes,
      fileSize: fileSize,
      resolution: .init(cgSize: size),
      duration: duration,
      imageTimeInterval: imageTimeInterval,
      fileExtension: fileExtension,
      configuration: configuration
    )
  }

  public init(initial: RecordedVideo, name: String, notes: String) {
    self.init(
      videoUUID: initial.videoUUID,
      name: name,
      createdAt: initial.createdAt,
      notes: notes,
      fileSize: initial.fileSize,
      resolution: initial.resolution,

      duration: initial.duration,
      imageTimeInterval: initial.imageTimeInterval,
      fileExtension: initial.fileExtension,
      configuration: initial.configuration
    )
  }
}
