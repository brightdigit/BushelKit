//
//  VideoInfo.swift
//  BushelKit
//
//  Created by Leo Dion on 10/6/24.
//

public import Foundation




public struct RecordedVideo : Sendable, Codable {
  public init(
    videoUUID: UUID,
    name: String,
    createdAt : Date,
    notes : String,
    fileSize: UInt64,
    width: Int,
    height: Int,
    duration: Double,
    imageTimeInterval : Double,
    configuration: CaptureVideoConfiguration
  ) {
    self.videoUUID = videoUUID
    self.name = name
    self.createdAt = createdAt
    self.notes = notes
    self.fileSize = fileSize
    self.width = width
    self.height = height
    self.duration = duration
    self.imageTimeInterval = imageTimeInterval
    self.configuration = configuration
  }
  
  public init(
    videoUUID: UUID,
    name: String,
    createdAt : Date,
    notes : String,
    fileSize: UInt64,
    size: CGSize,
    duration: Double,
    imageTimeInterval : Double,
    configuration: CaptureVideoConfiguration
  ) {
    self.init(
      videoUUID: videoUUID,
      name: name,
      createdAt: createdAt,
      notes: notes,
      fileSize: fileSize,
      width: Int(size.width),
      height: Int(size.height),
      duration: duration,
      imageTimeInterval: imageTimeInterval,
      configuration: configuration
    )
  }
  public let videoUUID: UUID
  public let name : String
  public let createdAt : Date
  public let notes : String
  public let fileSize: UInt64
  public let width: Int
  public let height: Int
  public let imageTimeInterval : Double
  public let duration: Double
  public let configuration : CaptureVideoConfiguration
}

extension RecordedVideo {
  
  public enum Field : Sendable{
    case videoUUID
    case fileSize
    case naturalSize
  }
 public enum InfoError : Error {
    case missingField(Field)
    case assetError(Error)
   case fileManagerError(Error)
  }
}
