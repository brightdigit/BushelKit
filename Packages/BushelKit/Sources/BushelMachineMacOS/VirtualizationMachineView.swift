//
// VirtualizationMachineView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization)
  import BushelLogging
  import BushelViewsCore
  import Foundation
  import SwiftUI
  import Virtualization

  #warning("updateNSView to be called")
  #warning("why not to print the frame and other settings of VZVirtualMachineView")
  struct VirtualizationMachineView: NSViewRepresentable, LoggerCategorized {
    typealias NSViewType = VZVirtualMachineView
    let virtualMachine: VZVirtualMachine
    func makeNSView(context _: Context) -> VZVirtualMachineView {
      let view = VZVirtualMachineView(
        frame: .init(origin: .zero, size: .init(width: 1920, height: 1080))
      )
      view.virtualMachine = virtualMachine

      Task { @MainActor in
        Self.logger.debug("Making View First Responder")
        view.window?.makeFirstResponder(view)
      }
      return view
    }

    func updateNSView(_: VZVirtualMachineView, context _: Context) {}
  }
#endif
