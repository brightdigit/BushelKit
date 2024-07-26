//
// PersistentModel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelLogging

  public import Foundation

  public import SwiftData

  extension PersistentModel where Self: Loggable {
    public static var loggingCategory: BushelLogging.Category {
      .data
    }
  }
#endif
