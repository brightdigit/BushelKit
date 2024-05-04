//
// InitializedSession.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(XPC)
  import BushelSession
  import BushelSessionCore
  import XPC

  @available(iOS, unavailable)
  public extension InitializedSession {
    convenience init(xpcService: String) {
      self.init {
        try XPCSession(xpcService: xpcService)
      }
    }
  }
#endif
