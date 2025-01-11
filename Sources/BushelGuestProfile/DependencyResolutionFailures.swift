//
//  DependencyResolutionFailures.swift
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

public import Foundation

// MARK: - DependencyResolutionFailures

/// A struct that represents failures in dependency resolution.
public struct DependencyResolutionFailures: Codable, Equatable, Sendable {
  /// The coding keys for the `DependencyResolutionFailures` struct.
  public enum CodingKeys: String, CodingKey {
    /// The case for no kexts found for the given libraries.
    case noKextsFoundForTheseLibraries = "No kexts found for these libraries"
  }

  /// An array of library names for which no kexts were found.
  public let noKextsFoundForTheseLibraries: [String]

  /// Initializes a `DependencyResolutionFailures` instance with the given `noKextsFoundForTheseLibraries`.
  ///
  /// - Parameter noKextsFoundForTheseLibraries: An array of library names for which no kexts were found.
  public init(noKextsFoundForTheseLibraries: [String]) {
    self.noKextsFoundForTheseLibraries = noKextsFoundForTheseLibraries
  }
}
