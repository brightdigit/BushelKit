//
// Message.swift
// Copyright (c) 2024 BrightDigit.
//

public protocol Message: Codable, Sendable {
  associatedtype ResponseType: Codable & Sendable
  func run(from service: any ServiceInterface) async throws -> ResponseType
}
