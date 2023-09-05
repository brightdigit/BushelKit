//
// VZMachine+Sessionable.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization) && arch(arm64)
  import BushelSessionUI
  import Foundation
  import SwiftUI

  extension VZMachine: Sessionable {
    func view() -> some View {
      VirtualizationMachineView(virtualMachine: self.machine)
    }
  }
#endif
