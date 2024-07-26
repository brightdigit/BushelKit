//
// VirtualizationMachine+Sessionable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelScreenCore
  import Foundation
  import SwiftUI

  extension VirtualizationMachine: Sessionable {
    @MainActor func view(_ settings: Binding<ScreenSettings>) -> some View {
      VirtualizationScreenView(virtualMachine: self.machine, settings: settings)
    }
  }
#endif
