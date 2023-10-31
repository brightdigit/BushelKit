//
// ScreenView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(Virtualization)
  import BushelCore
  import BushelLogging
  import BushelSessionUI
  import SwiftUI
  import Virtualization

  struct ScreenView: NSViewControllerRepresentable, LoggerCategorized {
    typealias NSViewControllerType = VirtualizationScreenViewController

    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }

    let virtualMachine: VZVirtualMachine
    @Binding var settings: ScreenSettings

    internal init(virtualMachine: VZVirtualMachine, settings: Binding<ScreenSettings>) {
      self.virtualMachine = virtualMachine
      self._settings = settings
    }

    func makeNSViewController(context _: Context) -> VirtualizationScreenViewController {
      .init(virtualMachine: virtualMachine)
    }

    func updateNSViewController(_ controller: VirtualizationScreenViewController, context _: Context) {
      Self.logger.debug("Updating screen settings \(settings.debugDescription)")
      controller.contentView.capturesSystemKeys = settings.capturesSystemKeys
      controller.contentView.automaticallyReconfiguresDisplay = settings.automaticallyReconfiguresDisplay
    }
  }

#endif
