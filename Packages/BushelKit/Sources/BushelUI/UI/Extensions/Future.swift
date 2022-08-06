//
// Future.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

//
// Future.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//
//
import Combine

extension Future where Failure == Never {
  @available(*, deprecated)
  convenience init<SuccessType>(operation: @escaping () async throws -> SuccessType) where Output == Result<SuccessType, Error> {
    self.init { promise in
      Task {
        do {
          let output = try await operation()
          promise(.success(.success(output)))
        } catch {
          promise(.success(.failure(error)))
        }
      }
    }
  }
}