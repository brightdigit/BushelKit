//
// Result.swift
// Copyright (c) 2023 BrightDigit.
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
}
