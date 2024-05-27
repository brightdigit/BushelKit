//
// FeedbackValue.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelFeedbackCore
import Foundation

internal struct FeedbackValue: FeedbackItem {
  internal let message: String

  internal let name: String

  internal let email: String

  internal let comments: String

  internal var type: FeedbackType {
    .message(message)
  }

  internal init(message: String, name: String, email: String, comments: String = "") {
    self.message = message
    self.name = name
    self.email = email
    self.comments = comments
  }
}
