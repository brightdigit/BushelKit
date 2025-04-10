//
//  SignatureSource.swift
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

internal import BushelUtilities
public import Foundation
public import OSVer

/// Represents the source of a signature, either an operating system version or a signature ID.
public enum SignatureSource: Sendable, CustomDebugStringConvertible {
  /// Represents a signature identified by a string.
  case signatureID(String)

  /// Represents an operating system version, optionally with a build version.
  case operatingSystemVersion(OSVer, String?)
}

extension SignatureSource {
  /// A string representation of the `SignatureSource` for debugging purposes.
  public var debugDescription: String {
    switch self {
    case let .operatingSystemVersion(version, build):
      "os:\(version.id(buildVersion: build))"
    case let .signatureID(signature):
      "sig:\(signature)"
    }
  }

  /// Creates a `SignatureSource` from a URL, if possible.
  ///
  /// - Parameter url: The URL to be converted to a `SignatureSource`.
  /// - Returns: A `SignatureSource` if the URL is valid, or `nil` if the URL is not valid.
  public static func url(_ url: URL) -> Self? {
    guard url.scheme?.starts(with: "http") != false else {
      return nil
    }
    return .signatureID(url.standardized.description)
  }
}
