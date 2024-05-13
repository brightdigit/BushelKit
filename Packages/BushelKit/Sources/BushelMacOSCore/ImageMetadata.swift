//
//  ImageMetadata.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

#if canImport(Virtualization) && arch(arm64)

  import BushelCore
  import Virtualization

  extension ImageMetadata {
    internal init(
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

    private init(contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage) {
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
