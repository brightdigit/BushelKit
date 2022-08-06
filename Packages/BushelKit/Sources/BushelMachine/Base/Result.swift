//
// Result.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

extension Result {
  public init(catching body: () async throws -> Success) async where Failure == Error {
    do {
      self = try await .success(body())
    } catch {
      self = .failure(error)
    }
  }

  func tupleWith<OtherSuccessType>(_ other: Result<OtherSuccessType, Failure>) -> Result<(Success, OtherSuccessType), Failure> {
    flatMap { success in
      other.map { other in
        (success, other)
      }
    }
  }

  func unwrap<NewSuccessType>(error: Failure) -> Result<NewSuccessType, Failure> where Success == NewSuccessType? {
    flatMap { optValue in
      guard let value = optValue else {
        return .failure(error)
      }
      return .success(value)
    }
  }

  @inlinable public func flatMap<NewSuccess>(_ transform: (Success) async throws -> NewSuccess) async -> Result<NewSuccess, Failure> where Failure == Error {
    let oldSuccess: Success

    switch self {
    case let .failure(failure):
      return .failure(failure)
    case let .success(success):
      oldSuccess = success
    }

    let result: Result<NewSuccess, Failure>
    do {
      let newSuccess = try await transform(oldSuccess)
      result = .success(newSuccess)
    } catch {
      result = .failure(error)
    }

    return result
  }

  var failure: Error? {
    guard case let .failure(error) = self else {
      return nil
    }
    return error
  }
}
