//
// AnyResultSet.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine)
  import Combine

  public extension Publishers {
    struct AnyResultSet<SuccessType, FailureType> {
      init<
        SuccessPublisher: Publisher,
        FailurePublisher: Publisher
      >(
        _ set: AsResultSet<SuccessPublisher, FailurePublisher>
      ) where SuccessPublisher.Output == SuccessType, FailurePublisher.Output == FailureType {
        success = set.success.eraseToAnyPublisher()
        failure = set.failure.eraseToAnyPublisher()
      }

      let success: AnyPublisher<SuccessType, Never>
      let failure: AnyPublisher<FailureType, Never>
    }
  }
#endif
