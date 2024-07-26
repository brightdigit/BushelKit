//
// Subscription+Offer.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

extension Subscription {
  public struct Offer: Sendable {
    public enum Kind: Sendable {
      case introductory

      case promotional

      case code

      case unknown(rawValue: Int)
    }

    public init(type: Subscription.Offer.Kind, id: String) {
      self.type = type
      self.id = id
    }

    public let type: Kind
    public let id: String
  }
}
