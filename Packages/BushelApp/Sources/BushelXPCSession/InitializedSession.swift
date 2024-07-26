//
// InitializedSession.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(XPC)
  public import BushelSession
  import BushelSessionCore
  import XPC

  @available(iOS, unavailable)
  extension InitializedSession {
    public convenience init(xpcService: String) {
      self.init {
        try XPCSession(xpcService: xpcService)
      }
    }
  }
#endif
