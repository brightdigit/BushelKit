//
// BookmarkedError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public protocol BookmarkedError: Error {
  static func databaseError(_ error: any Error) -> Self
  static func bookmarkError(_ error: any Error) throws -> Self
  static func missingBookmark() -> Self
  static func accessDeniedError(at url: URL) -> Self
}
