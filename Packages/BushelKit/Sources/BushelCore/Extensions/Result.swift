//
// Result.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension Result {
  init(catching body: () async throws -> Success) async where Failure == Error {
    do {
      self = try await .success(body())
    } catch {
      self = .failure(error)
    }
  }

  func unwrap<NewSuccess>(or failure: Failure) -> Result<NewSuccess, Failure> where Success == NewSuccess? {
    self.flatMap { value in
      if let value {
        .success(value)
      } else {
        .failure(failure)
      }
    }
  }
}
