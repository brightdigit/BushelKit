//
//  ImageInfo.swift
//  BushelKit
//
//  Created by Leo Dion on 10/7/24.
//

public import Foundation


public struct RecordedImage : Sendable, Codable{
  public enum Field : Sendable{
    case imageUUID
    case size
    case fileSize
  }
  public enum InfoError : Error {
    case missingField(Field)
    case innerError(Error)
  }
  internal init(
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
  
  public let imageUUID: UUID
  public let name : String
  public let notes : String
  public let createdAt : Date
  public let width : Int
  public let height : Int
  public let fileSize : UInt64
  public let configuration: CaptureImageConfiguration
}







extension RecordedImage {
  init(imageUUID: UUID,
       name : String,
notes : String,
createdAt : Date,
       size: CGSize, fileSize: UInt64, configuration: CaptureImageConfiguration) {
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
