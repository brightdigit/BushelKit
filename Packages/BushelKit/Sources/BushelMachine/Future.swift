//
// Future.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Combine)
  import Combine

  public extension Future where Failure == Error {
    convenience init(operation: @escaping () async throws -> Output) {
      self.init { promise in
        Task {
          do {
            let output = try await operation()
            promise(.success(output))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
  }

  public extension Future where Failure == Never {
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
#endif
