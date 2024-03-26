//
// InstallFailure.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct InstallFailure: Equatable {
  static let unknown: InstallFailure = .init(
    errorDomain: "Unknown",
    errorCode: 0,
    failureCode: 0,
    description: "Unknown Error",
    isSystem: true
  )

  let errorDomain: String
  let errorCode: Int
  let failureCode: Int
  let description: String
  let isSystem: Bool

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

  static func fromError(_ error: any Error) -> InstallFailure {
    guard let error = error as? any InstallFailureError else {
      assertionFailure(error: error)
      return .unknown
    }

    return error.installationFailure() ?? .unknown
  }
}
