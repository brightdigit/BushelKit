//
// MockCommand.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  @testable import BushelService
  import Foundation

  internal struct MockCommand: Command {
    let message: MockMessage
    let error: MockError
    internal init(message: MockMessage = .init(), error: MockError = .init()) {
      self.message = message
      self.error = error
    }

    func decode<T>(as _: T.Type) throws -> T where T: Decodable {
      guard let message = message as? T else {
        throw error
      }
      return message
    }
  }
#endif
