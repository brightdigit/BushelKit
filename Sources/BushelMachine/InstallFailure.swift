//
//  InstallFailure.swift
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

internal import BushelFoundation
public import Foundation

/// A struct representing an installation failure.
public struct InstallFailure: Equatable, Sendable {
  public struct Link: Equatable, Sendable {
    public let localizedTitle: String
    public let url: URL

    public init(
      localizedTitle: String,
      url: URL
    ) {
      self.localizedTitle = localizedTitle
      self.url = url
    }
  }

  /// The unknown installation failure case.
  private static let unknown: InstallFailure = .init(
    errorDomain: "Unknown",
    errorCode: 0,
    failureCode: 0,
    description: "Unknown Error",
    isSystem: true
  )

  /// The error domain.
  public let errorDomain: String
  /// The error code.
  public let errorCode: Int
  /// The failure code.
  public let failureCode: Int
  /// The description of the failure.
  public let description: String
  /// A boolean indicating whether the failure is a system error.
  public let isSystem: Bool
  /// An optional link associated with the failure.
  public let link: Link?

  /// Initializes an `InstallFailure` instance.
  ///
  /// - Parameters:
  ///   - errorDomain: The error domain.
  ///   - errorCode: The error code.
  ///   - failureCode: The failure code.
  ///   - description: The description of the failure.
  ///   - isSystem: A boolean indicating whether the failure is a system error. Defaults to `true`.
  public init(
    errorDomain: String,
    errorCode: Int,
    failureCode: Int,
    description: String,
    isSystem: Bool = true,
    link: Link? = nil
  ) {
    self.errorDomain = errorDomain
    self.errorCode = errorCode
    self.failureCode = failureCode
    self.description = description
    self.isSystem = isSystem
    self.link = link
  }

  /// Creates an `InstallFailure` instance from an `Error`.
  ///
  /// - Parameter error: The error to create the `InstallFailure` from.
  /// - Returns: The `InstallFailure` instance.
  internal static func fromError(_ error: any Error) -> InstallFailure {
    guard let error = error as? any InstallFailureError else {
      assertionFailure(error: error)
      return .unknown
    }

    return error.installationFailure() ?? .unknown
  }
}
