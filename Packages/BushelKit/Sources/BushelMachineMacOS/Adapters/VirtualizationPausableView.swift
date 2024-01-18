//
// VirtualizationPausableView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(Virtualization)

  import BushelLogging
  import Virtualization

  class VirtualizationPausableView: VZVirtualMachineView, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }

    var isEnabled: Bool = true {
      didSet {
        Self.logger.debug("Updating first responder \(self.isEnabled) for \(self.window != nil)")
        if isEnabled {
          self.alphaValue = 1.0
          self.window?.makeFirstResponder(self)
        } else {
          self.alphaValue = 0.6
          self.resignFirstResponder()
          self.window?.resignFirstResponder()
        }
      }
    }

    override func keyDown(with event: NSEvent) {
      guard isEnabled else {
        return
      }
      super.keyDown(with: event)
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
      guard isEnabled else {
        return nil
      }
      return super.hitTest(point)
    }
  }

#endif
