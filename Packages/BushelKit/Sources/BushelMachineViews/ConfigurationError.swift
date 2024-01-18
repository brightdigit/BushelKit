//
// ConfigurationError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData

  public enum ConfigurationError: LocalizedError {
    case missingRestoreImageID
    case missingSystemManager
    case restoreImageNotFound(UUID, library: LibraryIdentifier?)
    case imageNotSupported
    case databaseError(SwiftDataError)
    case machineBuilderError(BuilderError)
    case unknownError(Error)

    public var isFeedbackEnabled: Bool {
      switch self {
      case .imageNotSupported:
        true

      default:
        false
      }
    }

    public var isSystem: Bool {
      guard case let .machineBuilderError(builderError) = self else {
        return true
      }

      return builderError.isSystem
    }

    public var errorDescription: String? {
      switch self {
      case .missingRestoreImageID:
        "No restore image id was passed."
      case .missingSystemManager:
        "Missing system manager."
      case let .restoreImageNotFound:
        "Unable to find restore image."
      case .imageNotSupported:
        "Image is not supported for virtualization."
      case let .databaseError(error):
        "Database Error: \(error)"
      case let .machineBuilderError(error):
        error.errorDescription

      case let .unknownError(error):
        "Unknown error: \(error)"
      }
    }

    public var recoverySuggestion: String? {
      switch self {
      case .imageNotSupported, .machineBuilderError:
        "Please Try Another Restore Image."
      default:
        "Please Try Again."
      }
    }

    public var alertMessageText: String {
      switch self {
      default:
        self.recoverySuggestion ?? self.errorDescription ?? self.localizedDescription
      }
    }
  }
#endif
