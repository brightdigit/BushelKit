//
// InstallerImageIdentifier.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct InstallerImageIdentifier: CustomStringConvertible, Codable, Hashable {
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
    let libraryID: LibraryIdentifier?
    if components.count == 2 {
      libraryID = LibraryIdentifier(string: components[0])
    } else {
      libraryID = nil
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
