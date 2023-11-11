//
// BuilderError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public enum BuilderError: LocalizedError, Equatable {
  case corrupted(Property, dataAtURL: URL)
  case noSupportedConfigurationImage(MetadataLabel, isSupported: Bool)
  case installationFailure(InstallFailure)

  public typealias Property = BuilderProperty

  public var isSystem: Bool {
    guard case let .installationFailure(installationFailure) = self else {
      return false
    }
    return installationFailure.isSystem
  }

  public var errorDescription: String? {
    switch self {
    case let .corrupted(property, dataAtURL: url):
      return "The property \(property) data located at \(url.path) is corrupted"
    case let .noSupportedConfigurationImage(label, isSupported: true):
      return "This image \"\(label.operatingSystemLongName)\" contains no valid machine configuration."
    case let .noSupportedConfigurationImage(label, isSupported: false):
      return "This image \"\(label.operatingSystemLongName)\" is not supported."
    case let .installationFailure(error):
      return "There was an error during installation: \(error.description)"
    }
  }

  public var recoverySuggestion: String? {
    guard case .noSupportedConfigurationImage = self else {
      return nil
    }

    return "Use A Different Restore Image."
  }

  public static func fromInstallation(error: Error) -> BuilderError {
    .installationFailure(.fromError(error))
  }
}
