//
// ImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  import BushelCore
  import Virtualization

  extension ImageMetadata {
    init(
      vzRestoreImage: VZMacOSRestoreImage,
      headers: [AnyHashable: Any],
      from url: URL
    ) throws {
      guard let contentLengthString = headers["Content-Length"] as? String else {
        throw MissingAttributeError(.contentLength, from: url, headers: headers)
      }
      guard let contentLength = Int(contentLengthString) else {
        throw MissingAttributeError(.contentLength, from: url, headers: headers)
      }
      guard let lastModified =
        (headers["Last-Modified"] as? String)
          .flatMap(Formatters.lastModifiedDateFormatter.date(from:))
      else {
        throw MissingAttributeError(.lastModified, from: url, headers: headers)
      }

      self.init(
        contentLength: contentLength,
        lastModified: lastModified,
        vzRestoreImage: vzRestoreImage
      )
    }

    init(contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage) {
      self.init(
        isImageSupported: vzRestoreImage.isSupported,
        buildVersion: vzRestoreImage.buildVersion,
        operatingSystemVersion: vzRestoreImage.operatingSystemVersion,
        contentLength: contentLength,
        lastModified: lastModified,
        fileExtension: MacOSVirtualization.ipswFileExtension,
        vmSystemID: VMSystemID.macOS
      )
    }

    public init(
      vzRestoreImage: VZMacOSRestoreImage,
      url: URL
    ) async throws {
      if vzRestoreImage.url.isFileURL {
        let attrs = try FileManager.default.attributesOfItem(
          atPath: vzRestoreImage.url.path
        )
        guard
          let contentLength: Int = attrs[.size] as? Int else {
          throw MissingAttributeError(.size, from: url)
        }

        guard let lastModified = attrs[.modificationDate] as? Date
        else {
          throw MissingAttributeError(.modificationDate, from: url)
        }

        self.init(
          contentLength: contentLength,
          lastModified: lastModified,
          vzRestoreImage: vzRestoreImage
        )
      } else {
        let headers = try await vzRestoreImage.headers()
        try self.init(
          vzRestoreImage: vzRestoreImage,
          headers: headers,
          from: url
        )
      }
    }
  }

#endif
