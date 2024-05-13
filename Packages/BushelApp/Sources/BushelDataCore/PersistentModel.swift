//
// PersistentModel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelLogging
  import Foundation
  import SwiftData

  extension PersistentModel where Self: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }
  }
#endif
