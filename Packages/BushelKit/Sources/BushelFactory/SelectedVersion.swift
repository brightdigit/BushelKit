//
// SelectedVersion.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

public struct SelectedVersion: Hashable, Identifiable, Sendable {
  // swiftlint:disable:next force_unwrapping
  private static let noneID: UUID = .init(uuidString: "d4147e4c-d038-48ad-8410-d077e45d301a")!
  public static let none: SelectedVersion = .init()

  public let image: (any InstallerImage)?
  public var id: InstallerImageIdentifier {
    image?.identifier ?? .init(imageID: Self.noneID)
  }

  public init(image: any InstallerImage) {
    self.init(optionalImage: image)
  }

  private init(optionalImage: (any InstallerImage)? = nil) {
    self.image = optionalImage
  }

  public static func == (lhs: SelectedVersion, rhs: SelectedVersion) -> Bool {
    guard let lhsImage = lhs.image, let rhsImage = rhs.image else {
      return (lhs.image == nil) == (rhs.image == nil)
    }

    return lhsImage.imageID == rhsImage.imageID && lhsImage.libraryID == rhsImage.libraryID
  }

  public func hash(into hasher: inout Hasher) {
    guard let image else {
      return
    }

    hasher.combine(image.libraryID)
    hasher.combine(image.imageID)
  }
}
