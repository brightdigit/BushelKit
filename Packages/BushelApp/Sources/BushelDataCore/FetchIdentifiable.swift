//
// FetchIdentifiable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import SwiftData

  internal struct FetchIdentifiableError<Model: FetchIdentifiable>: Error {
    private let array: [Model]

    internal init(array: [Model]) {
      assert(array.count != 1)
      self.array = array
    }
  }

  public protocol FetchIdentifiable: PersistentModel, Sendable {
    var modelFetchDescriptor: FetchDescriptor<Self> {
      get
    }

    static func model(from array: [Self]) throws -> Self
  }

  extension FetchIdentifiable {
    public static func model(from array: [Self]) throws -> Self {
      assert(array.count == 1)
      guard let item = array.first else {
        throw FetchIdentifiableError(array: array)
      }
      return item
    }
  }
#endif
