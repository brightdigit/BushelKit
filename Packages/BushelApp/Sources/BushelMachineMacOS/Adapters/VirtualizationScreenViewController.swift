//
// VirtualizationScreenViewController.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(Virtualization)
  import AppKit
  import BushelLogging
  import Foundation
  import Virtualization

  @MainActor
  internal final class VirtualizationScreenViewController: NSViewController, Loggable {
    nonisolated static var loggingCategory: BushelLogging.Category {
      .view
    }

    var observation: NSKeyValueObservation?

    internal private(set) lazy var contentView = VirtualizationPausableView()

    var virtualMachine: VZVirtualMachine? {
      get {
        self.contentView.virtualMachine
      }
      set {
        Self.logger.debug("New virtual machine")
        observation = nil
        if let newMachine = newValue {
          observation = newMachine.observe(
            \.state,
            options: [.initial],
            changeHandler: { _, _ in Task { @MainActor in
              self.onVirtualMachine()
            }
            }
          )
          Self.logger.debug("Observing new machine state")
        }
        self.contentView.virtualMachine = newValue
      }
    }

    convenience init(virtualMachine: VZVirtualMachine) {
      self.init()
      self.virtualMachine = virtualMachine
    }

    override func loadView() {
      self.view = contentView
    }

    func onVirtualMachine() {
      guard let machineState = self.virtualMachine?.state else {
        return
      }
      let shouldBeEnabled = machineState == .running
      Self.logger.debug("Updating view to be enabled \(shouldBeEnabled) based on \(machineState.rawValue)")
      contentView.isEnabled = shouldBeEnabled
    }
  }

#endif
