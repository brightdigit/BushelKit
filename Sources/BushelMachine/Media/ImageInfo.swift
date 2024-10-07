//
//  ImageInfo.swift
//  BushelKit
//
//  Created by Leo Dion on 10/7/24.
//

public import Foundation


extension ImageInfo {
  init(imageUUID: UUID, size: CGSize, fileSize: UInt64, configuration: CaptureImage.Configuration) {
    self.init(
      imageUUID: imageUUID,
      width: .init(size.width),
      height: .init(size.height),
      fileSize: fileSize,
      configuration: configuration
    )
  }
}

public struct ImageInfo : Sendable{
  public enum Field : Sendable{
    case imageUUID
    case size
    case fileSize
  }
  public enum InfoError : Error {
    case missingField(Field)
    case innerError(Error)
  }
  internal init(imageUUID: UUID, width: Int, height: Int, fileSize: UInt64, configuration: CaptureImage.Configuration) {
    self.imageUUID = imageUUID
    self.width = width
    self.height = height
    self.fileSize = fileSize
    self.configuration = configuration
  }
  
  public let imageUUID: UUID
  public let width : Int
  public let height : Int
  public let fileSize : UInt64
  public let configuration: CaptureImage.Configuration
}


public protocol ImageInfoParser {
  func imageInfo(fromImage image: CaptureImage) throws(ImageInfo.InfoError) -> ImageInfo
}

public struct ImageFileParser : ImageInfoParser {
  public init(fileManager: FileManager, cgSizeFromURL: @escaping (URL) -> CGSize?) {
    self.cgSizeFromURL = cgSizeFromURL
    self.fileManager = fileManager
  }
  
  let cgSizeFromURL : (URL) -> CGSize?
  let fileManager : FileManager
  
  public func imageInfo(fromImage image: CaptureImage) throws(ImageInfo.InfoError) -> ImageInfo {
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
    
    return .init(
      imageUUID: imageUUID,
      size: size,
      fileSize: fileSize,
      configuration: image.configuration
    )
  }
}
