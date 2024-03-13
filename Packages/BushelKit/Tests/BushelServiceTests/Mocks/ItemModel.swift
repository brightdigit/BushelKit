//
// ItemModel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation
  import SwiftData

  class ItemModel: PersistentModel {
    static var schemaMetadata: [Schema.PropertyMetadata] = .init()

    var id: UUID

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
