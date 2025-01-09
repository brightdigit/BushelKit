//
//  BuilderError.swift
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
public import Foundation

/// Represents an error that occurred during the image building process.
public enum BuilderError: LocalizedError, Equatable, Sendable {
  /// Indicates that the property data located at the specified URL is corrupted.
  case corrupted(Property, dataAtURL: URL)

  /// Indicates that the specified image does not contain a valid machine configuration.
  case noSupportedConfigurationImage(MetadataLabel, isSupported: Bool)

  /// Indicates that there was a failure during the installation process.
  case installationFailure(InstallFailure)

  /// Indicates that there was an error while restoring the specified image.
  case restoreImage(any InstallerImage, RestoreImageFailure, withError: any Error)

  /// Indicates that the initialization of the installer was missing.
  case missingInitialization

  /// The type of the property that was corrupted.
  public typealias Property = BuilderProperty

  /// Represents the possible failures that can occur when restoring an image.
  public enum RestoreImageFailure: Sendable {
    /// Indicates that the image is corrupt.
    case corrupt

    /// Indicates that the image was not found.
    case notFound
  }

  /// Returns a boolean indicating whether the error is related to a system issue.
  public var isSystem: Bool {
    guard case let .installationFailure(installationFailure) = self else {
      return false
    }
    return installationFailure.isSystem
  }

  /// Returns a localized description of the error.
  public var errorDescription: String? {
    switch self {
    case let .corrupted(property, dataAtURL: url):
      "The property \(property) data located at \(url.path) is corrupted"
    case let .noSupportedConfigurationImage(label, isSupported: true):
      "This image \"\(label.operatingSystemLongName)\" contains no valid machine configuration."
    case let .noSupportedConfigurationImage(label, isSupported: false):
      "This image \"\(label.operatingSystemLongName)\" is not supported."
    case let .installationFailure(error):
      "There was an error during installation: \(error.description)"
    case let .restoreImage(image, _, withError: error):
      // swiftlint:disable:next line_length
      "Restore Image \"\(image.metadata.shortName)\" could not loaded due to error: \(error.localizedDescription)"
    case .missingInitialization:
      "Missing Installer Initialization"
    }
  }

  /// Returns a localized suggestion for recovering from the error, if applicable.
  public var recoverySuggestion: String? {
    switch self {
    case .noSupportedConfigurationImage, .restoreImage:
      "Use A Different Restore Image."
    default:
      nil
    }
  }

  /// Creates a `BuilderError` from an installation error.
  public static func fromInstallation(error: any Error) -> BuilderError {
    .installationFailure(.fromError(error))
  }

  /// Creates a `BuilderError` from an error that occurred while restoring an image.
  public static func restoreImage(_ image: any InstallerImage, withError error: NSError)
    -> BuilderError?
  {
    #if !os(Linux)
      let reason: NSError? = error.underlyingErrors.first as? NSError
      if reason?.localizedFailureReason?.contains("non-existent path") == true {
        return .restoreImage(image, .notFound, withError: error)
      }
    #endif
    return .restoreImage(image, .corrupt, withError: error)
  }

  /// Compares two `BuilderError` instances for equality.
  public static func == (lhs: BuilderError, rhs: BuilderError) -> Bool {
    switch (lhs, rhs) {
    case let (.corrupted(prop1, url1), .corrupted(prop2, url2)):
      prop1 == prop2 && url1 == url2
    case let (
      .noSupportedConfigurationImage(label1, isSupported1),
      .noSupportedConfigurationImage(label2, isSupported2)
    ):
      label1 == label2 && isSupported1 == isSupported2
    case let (.installationFailure(failure1), .installationFailure(failure2)):
      failure1 == failure2
    case let (.restoreImage(image1, failure1, error1), .restoreImage(image2, failure2, error2)):
      image1.metadata == image2.metadata
        && image1.libraryID == image2.libraryID
        && image1.imageID == image2.imageID
        && "\(error1)" == "\(error2)"
        && failure1 == failure2
    default:
      false
    }
  }
}
