//
// Array+Models.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation
  import SwiftData

  private let _models: [any PersistentModel.Type] = [
    LibraryImageEntry.self,
    LibraryEntry.self
  ]

  public extension Array where Element == any PersistentModel.Type {
    static var library: [any PersistentModel.Type] {
      _models
    }
  }
#endif
