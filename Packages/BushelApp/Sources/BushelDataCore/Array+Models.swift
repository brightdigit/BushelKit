//
// Array+Models.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import Foundation

  public import SwiftData

  private let _models: [any PersistentModel.Type] = [
    BookmarkData.self
  ]

  extension Array where Element == any PersistentModel.Type {
    public static var core: [any PersistentModel.Type] {
      _models
    }
  }
#endif
