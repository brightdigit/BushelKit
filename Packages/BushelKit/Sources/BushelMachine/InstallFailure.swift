//
//  InstallFailure.swift
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

import BushelCore
import Foundation

public struct InstallFailure: Equatable, Sendable {
  private static let unknown: InstallFailure = .init(
    errorDomain: "Unknown",
    errorCode: 0,
    failureCode: 0,
    description: "Unknown Error",
    isSystem: true
  )

  public let errorDomain: String
  public let errorCode: Int
  public let failureCode: Int
  public let description: String
  public let isSystem: Bool

  public init(
    errorDomain: String,
    errorCode: Int,
    failureCode: Int,
    description: String,
    isSystem: Bool = true
  ) {
    self.errorDomain = errorDomain
    self.errorCode = errorCode
    self.failureCode = failureCode
    self.description = description
    self.isSystem = isSystem
  }

  internal static func fromError(_ error: any Error) -> InstallFailure {
    guard let error = error as? any InstallFailureError else {
      assertionFailure(error: error)
      return .unknown
    }

    return error.installationFailure() ?? .unknown
  }
}
