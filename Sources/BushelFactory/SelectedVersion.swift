//
//  SelectedVersion.swift
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
public import BushelMachine
internal import Foundation

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
