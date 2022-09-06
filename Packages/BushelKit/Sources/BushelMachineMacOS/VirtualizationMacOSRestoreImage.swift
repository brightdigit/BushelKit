//
// VirtualizationMacOSRestoreImage.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Foundation
  import Virtualization

  public struct VirtualizationMacOSRestoreImage: ImageContainer {
    init(contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage, location: ImageLocation) {
      metadata = .init(contentLength: contentLength, lastModified: lastModified, vzRestoreImage: vzRestoreImage)
      self.vzRestoreImage = vzRestoreImage
      self.location = location
    }

    public let metadata: ImageMetadata
    // public let fileAccessor: FileAccessor?
    public var location: BushelMachine.ImageLocation

    let vzRestoreImage: VZMacOSRestoreImage

    public init(vzRestoreImage: VZMacOSRestoreImage, fileAccessor: FileAccessor?) async throws {
      if vzRestoreImage.url.isFileURL {
        let attrs = try FileManager.default.attributesOfItem(atPath: vzRestoreImage.url.path)
        guard let contentLength: Int = attrs[.size] as? Int, let lastModified = attrs[.modificationDate] as? Date else {
          throw VirtualizationError.undefinedType("Missing content length and lastModified from attrs", attrs)
        }
        self.init(contentLength: contentLength, lastModified: lastModified, vzRestoreImage: vzRestoreImage, location:
          fileAccessor.map(ImageLocation.file) ?? ImageLocation.file(URLAccessor(url: vzRestoreImage.url)))
      } else {
        let headers = try await vzRestoreImage.headers()
        try self.init(vzRestoreImage: vzRestoreImage, headers: headers, fileAccessor: fileAccessor)
      }
    }

    init(vzRestoreImage: VZMacOSRestoreImage, headers: [AnyHashable: Any], fileAccessor: FileAccessor?) throws {
      guard let contentLengthString = headers["Content-Length"] as? String else {
        throw MissingError.needDefinition((headers, "Content-Lenght"))
      }
      guard let contentLength = Int(contentLengthString) else {
        throw MissingError.needDefinition((headers, "Content-Lenght"))
      }
      guard let lastModified = (headers["Last-Modified"] as? String).flatMap(Formatters.lastModifiedDateFormatter.date(from:)) else {
        throw MissingError.needDefinition((headers, "Last-Modified"))
      }

      self.init(
        contentLength: contentLength,
        lastModified: lastModified,
        vzRestoreImage: vzRestoreImage,
        location: fileAccessor.map(ImageLocation.file) ?? .remote(vzRestoreImage.url)
      )
    }
  }
#endif
