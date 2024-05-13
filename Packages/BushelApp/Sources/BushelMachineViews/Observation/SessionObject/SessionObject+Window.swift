//
// SessionObject+Window.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import AppKit
  import BushelCore
  import Foundation
  import SwiftUI

  extension CGSize {
    @available(*, deprecated, message: "Should use BushelCore")
    @inlinable
    public func resizing(
      toAspectRatio aspectRatio: CGFloat,
      minimumWidth: CGFloat,
      withAdditionalHeight additionalHeight: CGFloat
    ) -> CGSize {
      let remainingHeight = max(self.height - additionalHeight, 0)
      let calculatedWidth = remainingHeight * aspectRatio
      if calculatedWidth < minimumWidth {
        return .init(width: minimumWidth, height: minimumWidth / aspectRatio + additionalHeight)
      } else {
        return .init(width: calculatedWidth, height: remainingHeight + additionalHeight)
      }
    }
  }

  extension SessionObject {
    var isMachineActive: Bool {
      !(self.machineObject?.state == .stopped || self.machineObject == nil || self.error != nil)
    }

    var capturesSystemKeys: Bool {
      get {
        self.screenSettings.capturesSystemKeys
      }
      set {
        self.screenSettings.capturesSystemKeys = newValue
      }
    }

    var automaticallyReconfiguresDisplay: Bool {
      get {
        self.screenSettings.automaticallyReconfiguresDisplay
      }
      set {
        self.screenSettings.automaticallyReconfiguresDisplay = newValue
      }
    }

    var aspectRatio: CGFloat? {
      guard let machineObject, !self.screenSettings.automaticallyReconfiguresDisplay else {
        return nil
      }

      let aspectRatios = machineObject.machine.configuration.graphicsConfigurations
        .flatMap(\.displays)
        .map(\.aspectRatio)
      guard let aspectRatio = aspectRatios.first, aspectRatios.count == 1 else {
        return nil
      }
      return aspectRatio
    }

    #if canImport(SwiftUI)
      func view() -> some View {
        @Bindable var object = self
        return machineObject?.sessionViewable?.anyView($object.screenSettings)
      }
    #endif

    func setWindow(_ window: NSWindow?) {
      self.window = window ?? self.window
    }

    @MainActor func updateWindowSize() {
      guard !self.initializedWindowSize else {
        return
      }

      guard self.state == .running else {
        return
      }

      guard let window = self.window else {
        return
      }

      guard let aspectRatio else {
        return
      }

      var frame = window.frame

      if (frame.size.height - self.toolbarHeight) * aspectRatio == frame.size.width {
        self.initializedWindowSize = true
        return
      }
      frame.size = frame.size.resizing(
        toAspectRatio: aspectRatio,
        minimumWidth: MachineScene.minimumWidth,
        withAdditionalHeight: toolbarHeight
      )
      Self.logger.debug("Resizing to initial size \(frame.size.debugDescription)")
      window.setFrame(frame, display: true)
      self.initializedWindowSize = true
    }

    func setCloseButtonAction(_ option: SessionCloseButtonActionOption?) {
      self.sessionCloseButtonActionOption = option
    }

    func shouldCloseWindow(_: NSWindow) -> Bool {
      guard isMachineActive else {
        return true
      }
      switch self.sessionCloseButtonActionOption {
      case .saveSnapshotAndForceTurnOff:
        self.stop(saveSnapshot: .init())

      case .forceTurnOff:
        self.stop(saveSnapshot: nil)

      default:
        self.presentConfirmCloseAlert = true
      }
      return false
    }

    func toolbarProxy(_ proxy: GeometryProxy) {
      self.toolbarHeight = proxy.size.height + 24.0
    }
  }
#endif
