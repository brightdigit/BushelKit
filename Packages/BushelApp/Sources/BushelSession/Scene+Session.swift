//
// Scene+Session.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelMessageCore

  public import BushelSessionCore
  import BushelSessionEnvironment
  import Foundation

  public import SwiftUI

  extension Scene {
    public func session(
      _ initializer: @escaping @Sendable () throws -> any SessionService
    ) -> some Scene {
      self.environment(\.session, InitializedSession(initializer: initializer))
    }
  }
#endif
