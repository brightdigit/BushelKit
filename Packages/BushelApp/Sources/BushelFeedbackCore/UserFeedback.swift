//
// UserFeedback.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation
#if canImport(Sentry)
  import Sentry

  extension UserFeedback {
    convenience init(feedback: any FeedbackItem) {
      let eventID: SentryId = switch feedback.type {
      case let .message(message):
        SentrySDK.capture(message: message)
      case let .eventID(id):
        SentryId(uuid: id)
      }

      self.init(eventId: eventID)
      self.name = feedback.name
      self.email = feedback.email
      self.comments = feedback.comments
    }
  }
#endif
