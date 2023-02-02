//
// VirtualizationMachineView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization)
  import Foundation
  import SwiftUI
  import Virtualization

  struct VirtualizationMachineView: NSViewRepresentable {
    let virtualMachine: VZVirtualMachine
    func makeNSView(context _: Context) -> VZVirtualMachineView {
      let view = VZVirtualMachineView(
        frame: .init(origin: .zero, size: .init(width: 1920, height: 1080))
      )
      view.virtualMachine = virtualMachine

      return view
    }

    func updateNSView(_: VZVirtualMachineView, context _: Context) {}

    typealias NSViewType = VZVirtualMachineView
  }
#endif
