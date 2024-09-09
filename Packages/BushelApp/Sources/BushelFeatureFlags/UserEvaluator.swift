//
// UserEvaluator.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

public actor UserEvaluator {
  internal static let evaluate = UserEvaluator([VersionEvaluator()])

  var registrations = [ObjectIdentifier: UserEvaluatorComponent]()

  private init(_ registrations: [any UserEvaluatorComponent] = []) {
    self.registrations = .init(uniqueKeysWithValues: registrations.map {
      ($0.key, $0)
    })
  }

  public static func register(_ component: UserEvaluatorComponent) {
    Task {
      await evaluate.register(component)
    }
  }

  func register(_ component: UserEvaluatorComponent) {
    self.registrations[component.key] = component
  }

  func callAsFunction(_ audience: UserAudience) async -> Bool {
    var avialableValues = UserAudience.none
    var audienceMatches = UserAudience.none

    for (_, registration) in registrations {
      avialableValues.formUnion(type(of: registration).evaluatingValue)
      await audienceMatches.formUnion(registration.evaluateValue(for: audience))
    }

    assert(avialableValues == .availableValues)
    return !audienceMatches.isEmpty
  }
}
