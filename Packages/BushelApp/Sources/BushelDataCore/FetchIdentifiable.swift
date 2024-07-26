//
// FetchIdentifiable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  public import SwiftData

  internal struct FetchIdentifiableError<Model: FetchIdentifiable>: Error {
    private let array: [Model]

    internal init(array: [Model]) {
      assert(array.count != 1)
      self.array = array
    }
  }

  public protocol FetchIdentifiable: PersistentModel, Sendable {
    static func model(from array: [Self]) throws -> Self

    @Sendable
    func selectDescriptor() -> FetchDescriptor<Self>
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
