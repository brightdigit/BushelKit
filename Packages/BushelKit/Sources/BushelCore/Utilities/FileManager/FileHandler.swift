//
// FileHandler.swift
// Copyright (c) 2024 BrightDigit.
//

@preconcurrency import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol FileHandler: Sendable {
  func attributesAt(_ url: URL) async throws -> any AttributeSet
  func copy(at fromURL: URL, to toURL: URL) async throws
}
