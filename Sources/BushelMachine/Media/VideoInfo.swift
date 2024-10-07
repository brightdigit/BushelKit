//
//  VideoInfo.swift
//  BushelKit
//
//  Created by Leo Dion on 10/6/24.
//

public import Foundation

public struct VideoProperties : Sendable{
  internal init(
    videoUUID: UUID,
    fileSize: UInt64,
    naturalSize: VideoProperties.NaturalSize,
    duration: Double
  ) {
    self.videoUUID = videoUUID
    self.fileSize = fileSize
    self.naturalSize = naturalSize
    self.duration = duration
  }
  
  public let videoUUID: UUID
  public let fileSize: UInt64
  public let naturalSize : NaturalSize
  public let duration: Double
  
  public struct NaturalSize: Sendable {
    internal init(width: Int, height: Int) {
      self.width = width
      self.height = height
    }
    
    public let width: Int
    public let height: Int
  }
}

extension VideoProperties {
  public init(
    videoUUID: UUID,
    fileSize: UInt64,
    size: CGSize,
    duration: Double
  ) {
    self.init(
      videoUUID: videoUUID,
      fileSize: fileSize,
      naturalSize: .init(size: size),
      duration: duration
    )
  }
}

extension VideoProperties.NaturalSize {
  public init (size: CGSize) {
    self.init(
      width: Int(size.width),
      height: Int(size.height)
    )
  }
}

public protocol VideoParser : Sendable {
  func propertiesFromURL(_ url: URL) async throws (VideoProperties.InfoError) -> VideoProperties
}

public struct VideoInfo : Sendable {
  public init(videoUUID: UUID, fileSize: UInt64, width: Int, height: Int, duration: Double) {
    self.videoUUID = videoUUID
    self.fileSize = fileSize
    self.width = width
    self.height = height
    self.duration = duration
  }
  
  public let videoUUID: UUID
  public let fileSize: UInt64
  public let width: Int
  public let height: Int
  public let duration: Double
}

extension VideoProperties {
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

extension VideoInfo {
  public init(properties: VideoProperties) {
    self.init(
      videoUUID: properties.videoUUID,
      fileSize: properties.fileSize,
      width: properties.naturalSize.width,
      height: properties.naturalSize.height,
      duration: properties.duration
    )
  }
  public init(
    capture video: CaptureVideo,
    using parser: any VideoParser
  ) async throws (VideoProperties.InfoError) {
    
    let properties = try await parser.propertiesFromURL(video.url)
    self.init(properties: properties)
  }
}
