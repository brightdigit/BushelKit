//
// Session.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelMessageCore

public protocol Session: Sendable {
  var isInitialized: Bool { get }
  var isReady: Bool { get }

  func sendMessage<MessageType: Message>(_ message: MessageType) async throws -> MessageType.ResponseType
}
