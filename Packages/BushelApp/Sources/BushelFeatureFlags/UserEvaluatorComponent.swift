//
// UserEvaluatorComponent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

public protocol UserEvaluatorComponent: Sendable {
  static var evaluatingValue: UserAudience { get }
  var key: ObjectIdentifier { get }
  func evaluate(_ user: UserAudience) -> Bool
}

extension UserEvaluatorComponent {
  public var key: ObjectIdentifier {
    .init(Self.self)
  }

  public func evaluateValue(for user: UserAudience) -> UserAudience {
    self.evaluate(user) ? Self.evaluatingValue : .none
  }
}
