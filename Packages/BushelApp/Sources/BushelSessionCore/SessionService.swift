//
// SessionService.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelMessageCore

public protocol SessionService: AnyObject {
  func sendMessage<MessageType: Message>(_ message: MessageType) async throws -> MessageType.ResponseType
  func cancel(reason: ServiceCancelReason)
}
