//
//  MachineStorageSpecification.swift
//  Sublimation
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

public import Foundation

public struct MachineStorageSpecification: Codable, Identifiable, Equatable, Sendable {
  public let id: UUID
  public var size: UInt64
  public var label: String

  public init(id: UUID = .init(), label: String, size: UInt64) {
    self.id = id
    self.label = label
    self.size = size
  }
}

extension MachineStorageSpecification {
  // swiftlint:disable:next force_unwrapping
  private static let defaultPrimaryID = UUID(uuidString: "70fe323b-efc9-410f-b642-bc8e15636a49")!
  internal static let defaultPrimary: MachineStorageSpecification = MachineStorageSpecification(
    id: Self.defaultPrimaryID,
    label: "",
    size: Self.defaultSize
  )
  public static let defaultSize : UInt64 = UInt64(64 * 1_024 * 1_024 * 1_024)
  public static func `default`(forSystem system: any MachineSystem) -> MachineStorageSpecification {
    .init(label: system.defaultStorageLabel, size: Self.defaultSize)
  }
}
