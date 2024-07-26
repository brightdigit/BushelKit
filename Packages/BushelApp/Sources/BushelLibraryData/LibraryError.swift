//
// LibraryError.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelDataCore

public import BushelLibrary

public import Foundation

extension LibraryError: BookmarkedError {
  public static func databaseError(_ error: any Error) -> BushelLibrary.LibraryError {
    .fromDatabaseError(error)
  }

  public static func missingBookmark() -> Self {
    .missingInitializedProperty(.bookmarkData)
  }

  public static func accessDeniedError(at url: URL) -> Self {
    .accessDeniedError(nil, at: url)
  }
}
