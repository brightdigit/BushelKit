//
// Publishers.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

#if canImport(Combine)
  import Combine

  public extension Publishers {
    typealias MapDocumentContext<Upstream: Publisher, OutputType: DocumentContextual> =
      Publishers.CompactMap<FilterMap<Upstream, URL>, OutputType>
    typealias Union<Upstream: Publisher, OutputElementType: Hashable> =
      Map<Upstream, Set<OutputElementType>>

    typealias FilterMap<Upstream: Publisher, OutputType> =
      Publishers.MapKeyPath<Publishers.Filter<Upstream>, OutputType>

    typealias MapResult<Upstream: Publisher> =
      Publishers.Catch<
        Publishers.Map<
          Upstream,
          Result<Upstream.Output, Upstream.Failure>
        >,
        Just<
          Result<Upstream.Output, Upstream.Failure>
        >
      >

    typealias CompactMapOnlyFailure<
      Upstream: Publisher,
      SuccessType,
      FailureType: Error
    > = Publishers.CompactMap<Upstream, FailureType>
      where
      Upstream.Output == Swift.Result<SuccessType, FailureType>,
      Upstream.Failure == Never

    typealias CompactMapOnlySuccess<
      Upstream: Publisher,
      SuccessType,
      FailureType: Error
    > = Publishers.CompactMap<Upstream, SuccessType>
      where
      Upstream.Output == Result<SuccessType, FailureType>,
      Upstream.Failure == Never

    typealias SharedCompactMapOnlySuccess<Upstream: Publisher> =
      Publishers.CompactMapOnlySuccess<
        Publishers.Share<
          Publishers.MapResult<Upstream>
        >,
        Upstream.Output,
        Upstream.Failure
      >

    typealias SharedCompactMapOnlyFailure<Upstream: Publisher> =
      Publishers.CompactMapOnlyFailure<
        Publishers.Share<
          Publishers.MapResult<Upstream>
        >,
        Upstream.Output,
        Upstream.Failure
      >
  }
#endif
