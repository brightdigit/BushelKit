//
// FeedbackItem.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol FeedbackItem {
  var type: FeedbackType { get }
  var name: String { get }
  var email: String { get }
  var comments: String { get }
}
