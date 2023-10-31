//
// VirtualizationScreenViewController.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AppKit) && canImport(Virtualization)

  import AppKit
  import BushelLogging
  import Virtualization
  class VirtualizationScreenViewController: NSViewController, LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }

    var observation: NSKeyValueObservation?

    internal private(set) lazy var contentView = VZVirtualMachinePausableView()

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
            changeHandler: self.onVirtualMachine(_:stateChange:)
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

    func onVirtualMachine(
      _ machine: VZVirtualMachine,
      stateChange _: NSKeyValueObservedChange<VZVirtualMachine.State>
    ) {
      let shouldBeEnabled = machine.state == .running
      Self.logger.debug("Updating view to be enabled \(shouldBeEnabled) based on \(machine.state.rawValue)")
      contentView.isEnabled = shouldBeEnabled
    }
  }

#endif
