//
// InitializedSession.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelMessageCore

public import BushelSessionCore
import Foundation

public final class InitializedSession: Session {
  internal struct NotInitializedError: Error {}

  private let initializer: @Sendable () throws -> any SessionService
  private var session: (any SessionService)?
  private var error: (any Error)?

  public var isInitialized: Bool {
    session != nil || error != nil
  }

  public var isReady: Bool {
    session != nil
  }

  public init(initializer: @escaping @Sendable () throws -> any SessionService) {
    self.initializer = initializer

    self.initialize()
  }

  func initialize() {
    assert(!isInitialized)
    let result = Result {
      try self.initializer()
    }

    switch result {
    case let .success(session):
      self.session = session

    case let .failure(error):
      self.error = error
    }
  }

  public func sendMessage<MessageType: Message>(
    _ message: MessageType
  ) async throws -> MessageType.ResponseType {
    if let error {
      throw error
    }

    assert(session != nil)

    guard let session else {
      throw NotInitializedError()
    }

    return try await session.sendMessage(message)
  }

  deinit {
    self.session?.cancel(reason: .deinitialized)
  }
}
