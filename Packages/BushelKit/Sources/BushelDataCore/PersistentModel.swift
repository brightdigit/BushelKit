//
// PersistentModel.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLogging
  import Foundation
  import SwiftData

  public extension PersistentModel where Self: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .data
    }
  }
#endif
