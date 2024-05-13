//
//  InstallerImageIdentifier.swift
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

import Foundation

public struct InstallerImageIdentifier: CustomStringConvertible, Codable, Hashable, Sendable {
  public let libraryID: LibraryIdentifier?
  public let imageID: UUID

  public var description: String {
    let values: [String?] = [libraryID?.description, imageID.uuidString]
    return values.compactMap { $0 }.joined(separator: ":")
  }

  public init(imageID: UUID, libraryID: LibraryIdentifier? = nil) {
    self.libraryID = libraryID
    self.imageID = imageID
  }

  #warning("log meaningful message about else of guard statements here too")
  public init?(string: String) {
    let components = string.components(separatedBy: ":").filter { $0.isEmpty == false }
    guard components.count > 1, components.count < 4 else {
      return nil
    }
    guard let imageID = components.last.flatMap(UUID.init(uuidString:)) else {
      return nil
    }

    #warning("what does a nullable libraryID mean, maybe this case needs to be logged")
    let libraryID: LibraryIdentifier? = if components.count == 2 {
      LibraryIdentifier(string: components[0])
    } else {
      nil
    }
    self.init(imageID: imageID, libraryID: libraryID)
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    let value = Self(string: string)
    guard let value else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Could not parse")
    }
    self = value
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.description)
  }
}
