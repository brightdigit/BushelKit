//
// MergeResults.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(Combine)
  import Combine

  public extension Publishers {
    struct MergeResults<SuccessType, FailureType: Error> {
      internal init(sets: [Publishers.AnyResultSet<SuccessType, FailureType>]) {
        self.sets = sets
      }

      public init(_ builder: MergeResultBuilder<SuccessType, FailureType>) {
        self.init(sets: builder.sets)
      }

      let sets: [AnyResultSet<SuccessType, FailureType>]

      public func mergedSuccess() -> Publishers.MergeMany<AnyPublisher<SuccessType, Never>> {
        Publishers.MergeMany(sets.map(\.success))
      }

      public func mergedFailure() -> Publishers.MergeMany<AnyPublisher<FailureType, Never>> {
        Publishers.MergeMany(sets.map(\.failure))
      }
    }
  }
#endif
