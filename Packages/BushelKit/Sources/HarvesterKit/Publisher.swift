//
// Publisher.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(Combine)
  import Combine

  public extension Publisher {
    func tryMap<T>(
      _ transform: @escaping (Self.Output) throws -> T,
      onFailure failure: @escaping (Self.Output, Error) -> Void
    ) -> Publishers.CompactMap<Self, T> {
      compactMap { output in
        do {
          return try transform(output)
        } catch {
          failure(output, error)
          return nil
        }
      }
    }

    func mapResult() -> Publishers.MapResult<Self> {
      map {
        Result<Output, Failure>.success($0)
      }
      .catch {
        Just(Result<Output, Failure>.failure($0))
      }
    }

    func split<Upstream: Publisher>() -> Publishers.AsResultSet<
      Publishers.SharedCompactMapOnlySuccess<Upstream>,
      Publishers.SharedCompactMapOnlyFailure<Upstream>
    > where Self == Publishers.MapResult<Upstream> {
      Publishers.AsResultSet(fromMapResult: self)
    }

    func asResultSet() -> Publishers.AsResultSet<
      Publishers.SharedCompactMapOnlySuccess<Self>,
      Publishers.SharedCompactMapOnlyFailure<Self>
    > {
      Publishers.AsResultSet(upstream: self)
    }

    func compactMapOnlyFailure
    <SuccessType, FailureType: Error>()
      -> Publishers.CompactMapOnlyFailure<Self, SuccessType, FailureType>
      where
      Self.Failure == Never,
      Self.Output == Result<SuccessType, FailureType> {
      compactMap { result -> FailureType? in
        guard case let .failure(error) = result else {
          return nil
        }
        return error
      }
    }

    func compactMapOnlySuccess
    <SuccessType, FailureType: Error>() ->
      Publishers.CompactMapOnlySuccess<Self, SuccessType, FailureType>
      where
      Self.Failure == Never,
      Self.Output == Result<SuccessType, FailureType> {
      compactMap { result -> SuccessType? in
        guard case let .success(output) = result else {
          return nil
        }
        return output
      }
    }

    func filter<OutputType>(
      _ isIncluded: @escaping (Self.Output) -> Bool,
      map keyPath: KeyPath<Self.Output, OutputType>
    ) -> Publishers.FilterMap<Self, OutputType> {
      filter(isIncluded).map(keyPath)
    }

    func union<OutputElementType>(
      _ set: Set<OutputElementType>
    ) -> Publishers.Union<Self, OutputElementType>
      where Self.Output: Sequence, Self.Output.Element == OutputElementType {
      map { output in
        set.union(output)
      }
    }

    func union(_ set: Set<Self.Output>) -> Publishers.Union<Self, Self.Output> where Self.Output: Hashable {
      map { output in
        set.union([output])
      }
    }
  }

#endif
