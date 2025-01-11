//
//  SnapshotOptions.swift
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

/// Represents options for taking a snapshot of a view or layer.
public struct SnapshotOptions: OptionSet, Sendable {
  /// The raw value of the option set.
  public typealias RawValue = Int

  /// An option indicating that the snapshot can be discarded.
  public static let discardable: SnapshotOptions = .init(rawValue: 1)

  /// An option indicating that the snapshot should be taken by moving the view or layer.
  public static let byMoving: SnapshotOptions = .init(rawValue: 2)

  /// The raw value of the option set.
  public let rawValue: Int

  /// Initializes a `SnapshotOptions` instance with the given raw value.
  /// - Parameter rawValue: The raw value to initialize the option set with.
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
}
