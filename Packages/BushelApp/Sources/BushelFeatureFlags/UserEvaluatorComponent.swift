//
// UserEvaluatorComponent.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelCore

public protocol UserEvaluatorComponent: Sendable {
  static var evaluatingValue: UserAudience { get }
  var key: ObjectIdentifier { get }
  func evaluate(_ user: UserAudience) async -> Bool
}

extension UserEvaluatorComponent {
  public var key: ObjectIdentifier {
    .init(Self.self)
  }

  public func evaluateValue(for user: UserAudience) async -> UserAudience {
    await self.evaluate(user) ? Self.evaluatingValue : .none
  }
}
