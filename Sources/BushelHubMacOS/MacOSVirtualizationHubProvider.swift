//
//  MacOSVirtualizationHubProvider.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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
  internal import BushelFoundation

  public import BushelHub
  internal import BushelMacOSCore
  internal import Foundation
  internal import Virtualization

  public protocol MacOSVirtualizationHubProvider: Sendable {}

  @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
  extension MacOSVirtualization {
    fileprivate static let hubs: [Hub] = [
      Hub(
        title: "Apple",
        id: "apple",
        systemID: .macOS,
        signaturePriority: .always,
        count: 1,
        Self.hubImages
      )
    ]

    @Sendable
    fileprivate static func hubImages() async throws -> [HubImage] {
      let restoreImage = try await VZMacOSRestoreImage.unsafeFetchLatestSupported()
      let imageMetadata = try await ImageMetadata(
        vzRestoreImage: restoreImage,
        sigVerification: .signed,
        url: restoreImage.url
      )

      return [
        .init(
          title: self.defaultName(fromMetadata: imageMetadata),
          metadata: imageMetadata,
          verification: .signed,
          url: restoreImage.url
        )
      ]
    }
  }

  extension MacOSVirtualizationHubProvider {
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public var macOSHubs: [Hub] {
      MacOSVirtualization.hubs
    }
  }
#endif
