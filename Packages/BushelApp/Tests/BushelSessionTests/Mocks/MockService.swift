//
// MockService.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMessageCore
import BushelSessionCore
import Foundation

internal class MockService: SessionService {
  internal enum Error: Swift.Error {
    case wrongMessage
    case wrongResponse
  }

  var messagesSent = [any Message]()
  var reason: ServiceCancelReason?

  func sendMessage<MessageType>(
    _ message: MessageType
  ) async throws -> MessageType.ResponseType where MessageType: Message {
    self.messagesSent.append(message)
    guard let message = message as? MockMessage else {
      throw Error.wrongMessage
    }
    guard let response = message.response as? MessageType.ResponseType else {
      throw Error.wrongResponse
    }
    return response
  }

  func cancel(reason: ServiceCancelReason) {
    self.reason = reason
  }
}
