//
// VirtualizationMacOSRestoreImage.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelVirtualization
  import Foundation
  import Virtualization

  struct VirtualizationMacOSRestoreImage: ImageContainer {
    public let metadata: ImageMetadata
    // public let fileAccessor: FileAccessor?
    public var location: ImageLocation?

    let vzRestoreImage: VZMacOSRestoreImage
    init(
      contentLength: Int,
      lastModified: Date,
      vzRestoreImage: VZMacOSRestoreImage,
      location: ImageLocation
    ) {
      metadata = .init(
        contentLength: contentLength,
        lastModified: lastModified,
        vzRestoreImage: vzRestoreImage
      )
      self.vzRestoreImage = vzRestoreImage
      self.location = location
    }

    // swiftlint:disable:next function_body_length
    public init(
      vzRestoreImage: VZMacOSRestoreImage,
      fileAccessor: FileAccessor?
    ) async throws {
      if vzRestoreImage.url.isFileURL {
        let attrs = try FileManager.default.attributesOfItem(
          atPath: vzRestoreImage.url.path
        )
        guard
          let contentLength: Int = attrs[.size] as? Int,

          let lastModified = attrs[.modificationDate] as? Date else {
          throw VirtualizationError.undefinedType(
            "Missing content length and lastModified from attrs",
            attrs
          )
        }

        let location =
          fileAccessor.map(ImageLocation.file) ??
          ImageLocation.file(URLAccessor(url: vzRestoreImage.url))
        self.init(
          contentLength: contentLength,
          lastModified: lastModified,
          vzRestoreImage: vzRestoreImage,
          location: location
        )
      } else {
        let headers = try await vzRestoreImage.headers()
        try self.init(
          vzRestoreImage: vzRestoreImage,
          headers: headers,
          fileAccessor: fileAccessor
        )
      }
    }

    init(
      vzRestoreImage: VZMacOSRestoreImage,
      headers: [AnyHashable: Any],
      fileAccessor: FileAccessor?
    ) throws {
      guard let contentLengthString = headers["Content-Length"] as? String else {
        throw ManagerError.undefinedType("Content-Lenght", headers)
      }
      guard let contentLength = Int(contentLengthString) else {
        throw ManagerError.undefinedType("Content-Lenght", headers)
      }
      guard let lastModified =
        (headers["Last-Modified"] as? String)
          .flatMap(Formatters.lastModifiedDateFormatter.date(from:)) else {
        throw ManagerError.undefinedType("Last-Modified", headers)
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
