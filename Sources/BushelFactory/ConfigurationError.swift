//
//  ConfigurationError.swift
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
public import BushelMachine
public import Foundation

#if canImport(SwiftData)
  public import SwiftData
#else
  /// A stand-in error used on platforms where SwiftData is unavailable.
  public struct SwiftDataError: LocalizedError {}
#endif

/// An error describing why a machine configuration could not be created or resolved.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public enum ConfigurationError: LocalizedError {
  case missingRestoreImageID
  case missingSystemManager
  case restoreImageNotFound(UUID, library: LibraryIdentifier?)
  case imageNotSupported
  case databaseError(SwiftDataError)
  case machineBuilderError(BuilderError)
  case unknownError(any Error)
  case missingSpecifications
  case fileDialogError(any Error)

  /// A Boolean value indicating whether the user should be offered a way to submit feedback for this error.
  public var isFeedbackEnabled: Bool {
    switch self {
    case .imageNotSupported:
      true

    default:
      false
    }
  }

  /// A Boolean value indicating whether the error originates from the system rather than user input.
  public var isSystem: Bool {
    guard case let .machineBuilderError(builderError) = self else {
      return true
    }

    return builderError.isSystem
  }

  /// A localized description of what went wrong.
  public var errorDescription: String? {
    switch self {
    case .missingRestoreImageID:
      "No restore image id was passed."
    case .missingSystemManager:
      "Missing system manager."
    case .restoreImageNotFound:
      "Unable to find restore image."
    case .imageNotSupported:
      "Image is not supported for virtualization."
    case .missingSpecifications:
      "Specification not set."
    case let .databaseError(error):
      "Database Error: \(error)"
    case let .machineBuilderError(error):
      error.errorDescription
    case let .fileDialogError(error):
      error.localizedDescription
    case let .unknownError(error):
      "Unknown error: \(error)"
    }
  }

  /// A localized suggestion describing how the user might recover from the error.
  public var recoverySuggestion: String? {
    switch self {
    case .imageNotSupported, .machineBuilderError:
      "Please Try Another Restore Image."
    default:
      "Please Try Again."
    }
  }

  /// The message text to present in an alert for this error.
  public var alertMessageText: String {
    switch self {
    default:
      self.recoverySuggestion ?? self.errorDescription ?? self.localizedDescription
    }
  }
}
