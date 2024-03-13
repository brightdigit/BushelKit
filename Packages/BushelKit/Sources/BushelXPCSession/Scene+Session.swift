//
// Scene+Session.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(XPC) && canImport(SwiftUI)
  import BushelSession
  import BushelSessionCore
  import XPC

  import SwiftUI

  @available(iOS, unavailable)
  public extension Scene {
    func session(
      _ xpcService: String
    ) -> some Scene {
      self.environment(\.session, InitializedSession(xpcService: xpcService))
    }
  }
#endif
