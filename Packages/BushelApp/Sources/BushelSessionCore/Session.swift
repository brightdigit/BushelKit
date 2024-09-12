//
// Session.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelMessageCore

#warning("Fix XPC Session")
public protocol Session: Sendable {
  var isInitialized: Bool { get }
  var isReady: Bool { get }

  func sendMessage<MessageType: Message>(_ message: MessageType) async throws -> MessageType.ResponseType
}
