//
//  ImageInfo.swift
//  BushelKit
//
//  Created by Leo Dion on 10/7/24.
//

public import Foundation


extension ImageInfo {
  init(imageUUID: UUID,
       name : String,
notes : String,
createdAt : Date,
       size: CGSize, fileSize: UInt64, configuration: CaptureImage.Configuration) {
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

public struct ImageInfo : Sendable, Codable{
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
    configuration: CaptureImage.Configuration
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
  public let configuration: CaptureImage.Configuration
}


public protocol ImageInfoParser {
  func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL) async throws(ImageInfo.InfoError) -> ImageInfo
}

public struct ImageFileParser : ImageInfoParser {
  public init(fileManager: FileManager, cgSizeFromURL: @escaping (URL) -> CGSize?) {
    self.cgSizeFromURL = cgSizeFromURL
    self.fileManager = fileManager
  }
  
  let cgSizeFromURL : (URL) -> CGSize?
  let fileManager : FileManager
  
  public func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL) async throws(ImageInfo.InfoError) -> ImageInfo {
    let url = image.url
    guard let imageUUID = UUID(uuidString: url.deletingPathExtension().lastPathComponent) else {
      throw .missingField(.imageUUID)
    }
    let fileSize : UInt64?
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
    let captureDestinationURL = directoryURL
      .appendingPathComponent(imageUUID.uuidString)
      .appendingPathExtension(for: .init(imageType: image.configuration.fileType))
    do {
      try self.fileManager.createEmptyDirectory(at: directoryURL, withIntermediateDirectories: false, deleteExistingFile: false)
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
