//
//  ImageFileParser.swift
//  Bushel
//
//  Created by Leo Dion on 10/8/24.
//

public import Foundation


public struct ImageFileParser : ImageInfoParser {
  public init(fileManager: FileManager, cgSizeFromURL: @escaping (URL) -> CGSize?) {
    self.cgSizeFromURL = cgSizeFromURL
    self.fileManager = fileManager
  }
  
  let cgSizeFromURL : (URL) -> CGSize?
  let fileManager : FileManager
  
  public func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL) async throws(RecordedImage.InfoError) -> RecordedImage {
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
