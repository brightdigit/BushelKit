//
//  Hub.swift
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

public import BushelFoundation
internal import Foundation

/// A source that aggregates and provides a collection of installable images.
public struct Hub: Hashable, Identifiable, Sendable {
  /// The human-readable title of the hub.
  public let title: String
  /// The unique identifier of the hub.
  public let id: String
  /// The number of images the hub provides, if known.
  public let count: Int?
  /// The signature priority applied to images from this hub.
  public let signaturePriority: SignaturePriority
  /// The virtual machine system the hub's images target.
  public let systemID: VMSystemID
  /// A closure that asynchronously fetches the hub's images.
  public let getImages: @Sendable () async throws -> [HubImage]

  /// Creates a hub.
  /// - Parameters:
  ///   - title: The human-readable title of the hub.
  ///   - id: The unique identifier of the hub.
  ///   - systemID: The virtual machine system the hub's images target.
  ///   - signaturePriority: The signature priority applied to the hub's images.
  ///   - count: The number of images the hub provides, if known.
  ///   - images: A closure that asynchronously fetches the hub's images.
  public init(
    title: String,
    id: String,
    systemID: VMSystemID,
    signaturePriority: SignaturePriority,
    count: Int?,
    _ images: @escaping @Sendable () async throws -> [HubImage]
  ) {
    self.title = title
    self.id = id
    self.signaturePriority = signaturePriority
    self.count = count
    self.systemID = systemID
    self.getImages = images
  }

  /// Returns a Boolean value indicating whether two hubs have the same identifier.
  /// - Parameters:
  ///   - lhs: The first hub to compare.
  ///   - rhs: The second hub to compare.
  /// - Returns: `true` if the hubs share the same identifier.
  public static func == (lhs: Hub, rhs: Hub) -> Bool {
    lhs.id == rhs.id
  }

  /// Hashes the hub's identifier into the given hasher.
  /// - Parameter hasher: The hasher to combine the hub's identifier into.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
