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

public struct Hub: Hashable, Identifiable, Sendable {
  public let title: String
  public let id: String
  public let count: Int?
  public let signaturePriority: SignaturePriority
  public let systemID: VMSystemID
  public let getImages: @Sendable () async throws -> [HubImage]

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

  public static func == (lhs: Hub, rhs: Hub) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
