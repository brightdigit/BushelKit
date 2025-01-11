//
//  RecordedVideo.swift
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

/// A struct representing a recorded video.
public struct RecordedVideo: Sendable, Codable {
  /// Represents the fields of a `RecordedVideo` instance.
  public enum Field: Sendable {
    /// The UUID of the video.
    case videoUUID
    /// The file size of the video.
    case fileSize
    /// The natural size of the video.
    case naturalSize
  }

  /// The UUID of the video.
  public let videoUUID: UUID
  /// The name of the video.
  public let name: String
  /// The date when the video was created.
  public let createdAt: Date
  /// The notes associated with the video.
  public let notes: String
  /// The file size of the video.
  public let fileSize: UInt64
  /// The resolution of the video.
  public let resolution: RecordedResolution
  /// The time interval between images.
  public let imageTimeInterval: Double
  /// The duration of the video.
  public let duration: Double
  /// The file extension of the video.
  public let fileExtension: String
  /// The configuration used to capture the video.
  public let configuration: CaptureVideoConfiguration

  /// Initializes a `RecordedVideo` instance.
  /// - Parameters:
  ///   - videoUUID: The UUID of the video.
  ///   - name: The name of the video.
  ///   - createdAt: The date when the video was created.
  ///   - notes: The notes associated with the video.
  ///   - fileSize: The file size of the video.
  ///   - resolution: The resolution of the video.
  ///   - duration: The duration of the video.
  ///   - imageTimeInterval: The time interval between images.
  ///   - fileExtension: The file extension of the video.
  ///   - configuration: The configuration used to capture the video.
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

  /// Initializes a `RecordedVideo` instance.
  /// - Parameters:
  ///   - videoUUID: The UUID of the video.
  ///   - name: The name of the video.
  ///   - createdAt: The date when the video was created.
  ///   - notes: The notes associated with the video.
  ///   - fileSize: The file size of the video.
  ///   - size: The size of the video.
  ///   - duration: The duration of the video.
  ///   - imageTimeInterval: The time interval between images.
  ///   - fileExtension: The file extension of the video.
  ///   - configuration: The configuration used to capture the video.
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

  /// Initializes a `RecordedVideo` instance with a new name and notes.
  /// - Parameters:
  ///   - initial: The initial `RecordedVideo` instance.
  ///   - name: The new name of the video.
  ///   - notes: The new notes associated with the video.
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
