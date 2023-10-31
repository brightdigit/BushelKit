//
// VZMachine+Sessionable.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelSessionUI
  import Foundation
  import SwiftUI

  extension VZMachine: Sessionable {
    func view(_ settings: Binding<ScreenSettings>) -> some View {
      ScreenView(virtualMachine: self.machine, settings: settings)
    }
  }
#endif
