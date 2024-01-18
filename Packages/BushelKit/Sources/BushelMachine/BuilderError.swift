//
// BuilderError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public enum BuilderError: LocalizedError, Equatable {
  case corrupted(Property, dataAtURL: URL)
  case noSupportedConfigurationImage(MetadataLabel, isSupported: Bool)
  case installationFailure(InstallFailure)
  case restoreImage(any InstallerImage, RestoreImageFailure, withError: Error)

  public typealias Property = BuilderProperty

  public enum RestoreImageFailure {
    case corrupt
    case notFound
  }

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
    case let .restoreImage(image, _, withError: error):
      // swiftlint:disable:next line_length
      return "Restore Image \"\(image.metadata.shortName)\" could not loaded due to error: \(error.localizedDescription)"
    }
  }

  public var recoverySuggestion: String? {
    switch self {
    case .noSupportedConfigurationImage, .restoreImage:
      "Use A Different Restore Image."
    default:
      nil
    }
  }

  public static func fromInstallation(error: Error) -> BuilderError {
    .installationFailure(.fromError(error))
  }

  public static func restoreImage(_ image: any InstallerImage, withError error: NSError) -> BuilderError? {
    #if !os(Linux)
      let reason: NSError = error.underlyingErrors[0] as NSError
      if reason.localizedFailureReason?.contains("non-existent path") == true {
        return .restoreImage(image, .notFound, withError: error)
      }
    #endif
    return .restoreImage(image, .corrupt, withError: error)
  }

  public static func == (lhs: BuilderError, rhs: BuilderError) -> Bool {
    switch (lhs, rhs) {
    case let (.corrupted(prop1, url1), .corrupted(prop2, url2)):
      return prop1 == prop2 && url1 == url2

    case let (
      .noSupportedConfigurationImage(label1, isSupported1),
      .noSupportedConfigurationImage(label2, isSupported2)
    ):
      return label1 == label2 && isSupported1 == isSupported2

    case let (.installationFailure(failure1), .installationFailure(failure2)):
      return failure1 == failure2

    case let (.restoreImage(image1, failure1, error1), .restoreImage(image2, failure2, error2)):
      return image1.metadata == image2.metadata
        && image1.libraryID == image2.libraryID
        && image1.imageID == image2.imageID
        && "\(error1)" == "\(error2)"
        && failure1 == failure2

    default:
      return false
    }
  }
}
