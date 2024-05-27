//
// ItemModel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation
  import SwiftData

  internal class ItemModel: PersistentModel, Sendable {
    static let schemaMetadata: [Schema.PropertyMetadata] = .init()

    let id: UUID

    // swiftlint:disable:next implicitly_unwrapped_optional
    var backingData: (any BackingData<ItemModel>)! = nil
    var persistentBackingData: any BackingData<ItemModel> {
      get {
        backingData
      }
      set {
        self.backingData = newValue
      }
    }

    required init(backingData: any BackingData<ItemModel>) {
      self.backingData = backingData
      self.id = .init()
    }

    init(id: UUID = .init()) {
      self.id = id
    }
  }
#endif
