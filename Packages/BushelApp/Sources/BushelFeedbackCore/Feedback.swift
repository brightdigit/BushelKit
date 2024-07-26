//
// Feedback.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

#if canImport(Sentry)
  import Sentry

  public enum Feedback {
    public static func createEventID(message: String) -> UUID {
      // swiftlint:disable:next force_unwrapping
      UUID(withoutSeparators: SentrySDK.capture(message: message).sentryIdString)!
    }

    public static func submit(_ item: any FeedbackItem) {
      SentrySDK.capture(userFeedback: .init(feedback: item))
    }
  }

  extension UUID {
    init?(withoutSeparators string: String) {
      // Ensure the string has the correct length
      guard string.count == 32 else {
        print("The string must be exactly 32 characters long.")
        return nil
      }

      // swiftlint:disable:next line_length
      let formattedString = "\(string.prefix(8))-\(string.dropFirst(8).prefix(4))-\(string.dropFirst(12).prefix(4))-\(string.dropFirst(16).prefix(4))-\(string.dropFirst(20))"

      // Create and return the UUID
      self.init(uuidString: formattedString)
    }
  }

#endif
