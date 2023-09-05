//
// ModelContainer.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import SwiftData

  public extension ModelContainer {
    static func forTypes(_ forTypes: [any PersistentModel.Type]) -> ModelContainer {
      // swiftlint:disable:next force_try
      try! .init(for: Schema(forTypes))
    }
  }
#endif
