//
// MergeResultBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(Combine)
  import Combine

  public extension Publishers {
    struct MergeResultBuilder<SuccessType, FailureType: Error> {
      public init(sets: [Publishers.AnyResultSet<SuccessType, FailureType>] = .init()) {
        self.sets = sets
      }

      var sets: [AnyResultSet<SuccessType, FailureType>]

      public mutating func append<SuccessPublisher, FailurePublisher>(
        _ resultSet: AsResultSet<SuccessPublisher, FailurePublisher>
      ) where SuccessPublisher.Output == SuccessType, FailurePublisher.Output == FailureType {
        sets.append(resultSet.eraseToAnyPublisher())
      }
    }
  }#endif
