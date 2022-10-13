//
// UserDefaultsEncoder.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Combine)
  import BushelMachine
  import Combine
  import Foundation
  import HarvesterKit

  struct UserDefaultsEncoder {
    var builder = Publishers.MergeResultBuilder<UserDefaultData, Error>()

    mutating func append<SuccessPublisher, FailurePublisher>(
      _ resultSet: Publishers.AsResultSet<SuccessPublisher, FailurePublisher>
    ) where SuccessPublisher.Output == UserDefaultData, FailurePublisher.Output == Error {
      builder.append(resultSet)
    }

    func callAsFunction<C>(
      _ receiveValue: @escaping (UserDefaultData) -> Void,
      onFailure receiveError: @escaping (Error) -> Void,
      storeIn collection: inout C
    ) where C: RangeReplaceableCollection, C.Element == AnyCancellable {
      let results = Publishers.MergeResults(builder)
      results
        .mergedSuccess()
        .sink(receiveValue: receiveValue)
        .store(in: &collection)

      results
        .mergedFailure()
        .sink(receiveValue: receiveError)
        .store(in: &collection)
    }
  }
#endif
