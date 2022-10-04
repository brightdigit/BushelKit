//
// View.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI) && canImport(os)
  import os
  import SwiftUI
  extension View {
    static var logger: Logger {
      Logger.forCategory(.ui)
    }
  }
#endif
