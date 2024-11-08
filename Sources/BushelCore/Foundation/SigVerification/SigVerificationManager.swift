//
//  SigVerificationManager.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//


public struct SigVerificationManager: SigVerificationManaging {
  private init(implementations: [VMSystemID: any SigVerifier]) {
    self.implementations = implementations
  }

  public init(_ implementations: [any SigVerifier]) {
    self.init(implementations: .init(uniqueValues: implementations, keyBy: \.id))
  }

  private let implementations: [VMSystemID: any SigVerifier]

  public func resolve(_ id: BushelCore.VMSystemID) -> any BushelCore.SigVerifier {
    guard let implementations = implementations[id] else {
      // Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
