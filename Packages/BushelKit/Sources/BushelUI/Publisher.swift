//
// Publisher.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Combine)
  import Combine

  extension Publisher {
    func tryMap<T>(_ transform: @escaping (Self.Output) throws -> T, onFailure failure: @escaping (Self.Output, Error) -> Void) -> Publishers.CompactMap<Self, T> {
      compactMap { output in
        do {
          return try transform(output)
        } catch {
          failure(output, error)
          return nil
        }
      }
    }
  }
#endif
