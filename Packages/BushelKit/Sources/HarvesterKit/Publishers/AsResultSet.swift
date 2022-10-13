//
// AsResultSet.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

#if canImport(Combine)
  import Combine

  public extension Publishers.AsResultSet {
    func eraseToAnyPublisher()
      -> Publishers.AnyResultSet<SuccessPublisher.Output, FailurePublisher.Output> {
      .init(self)
    }

    func map<NewSuccessType>(_ transform: @escaping (SuccessPublisher.Output) -> (NewSuccessType))
      -> Publishers.AsResultSet<Publishers.Map<SuccessPublisher, NewSuccessType>, FailurePublisher> {
      Publishers.AsResultSet(success: success.map(transform), failure: failure)
    }

    init<Upstream: Publisher>(fromMapResult upstream: Publishers.MapResult<Upstream>)
      where

      SuccessPublisher == Publishers.SharedCompactMapOnlySuccess<Upstream>,
      FailurePublisher == Publishers.SharedCompactMapOnlyFailure<Upstream> {
      let shared = upstream.share()

      self.init(
        success: shared.compactMapOnlySuccess(),
        failure: shared.compactMapOnlyFailure()
      )
    }

    init<Upstream: Publisher>(upstream: Upstream) where
      SuccessPublisher == Publishers.SharedCompactMapOnlySuccess<Upstream>,
      FailurePublisher == Publishers.SharedCompactMapOnlyFailure<Upstream> {
      self.init(fromMapResult: upstream.mapResult())
    }
  }

  public extension Publishers {
    struct AsResultSet<
      SuccessPublisher: Publisher,
      FailurePublisher: Publisher
    > where
      SuccessPublisher.Failure == Never,
      FailurePublisher.Failure == Never,
      FailurePublisher.Output: Error {
      internal init(success: SuccessPublisher, failure: FailurePublisher) {
        self.success = success
        self.failure = failure
      }

      let success: SuccessPublisher
      let failure: FailurePublisher
    }
  }
#endif
