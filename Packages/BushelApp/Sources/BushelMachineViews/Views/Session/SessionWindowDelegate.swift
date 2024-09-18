//
// SessionWindowDelegate.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit)
  import AppKit
  import BushelLogging
  import Foundation

  @MainActor
  internal class SessionWindowDelegate: NSObject, NSWindowDelegate, Loggable {
    nonisolated static let loggingCategory: BushelLogging.Category = .view

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var object: SessionObject!

    internal init(object: SessionObject) {
      self.object = object
    }

    func windowDidBecomeKey(_ notification: Notification) {
      guard object.windowNumber == nil else {
        return
      }

      guard let window = notification.object as? NSWindow else {
        assertionFailure("Unable to get window.")
        return
      }

      Self.logger.debug("Saving Window Number: \(window.windowNumber)")
      object.windowNumber = window.windowNumber
    }

    func windowDidBecomeMain(_ notification: Notification) {
      guard object.canStart, !object.hasIntialStarted else {
        return
      }

      object.hasIntialStarted = true
      object.begin { machine in
        try await machine.start()
      }

      guard object.windowNumber == nil else {
        return
      }

      guard let window = notification.object as? NSWindow else {
        assertionFailure("Unable to get window.")
        return
      }

      Self.logger.debug("Saving Window Number: \(window.windowNumber)")
      object.windowNumber = window.windowNumber
    }

    func windowWillResize(_: NSWindow, to frameSize: NSSize) -> NSSize {
      Self.logger.debug("windowWillResize to \(frameSize.debugDescription)")
      guard let aspectRatio = object.aspectRatio else {
        Self.logger.debug("windowWillResize no aspect ratio")
        return frameSize
      }
      let newSize = frameSize.resizing(
        toAspectRatio: aspectRatio,
        minimumWidth: MachineScene.minimumWidth,
        withAdditionalHeight: self.object.toolbarHeight
      )
      object.newSize = newSize
      Self.logger.debug("windowWillResize newSize \(newSize.debugDescription)")
      return newSize
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
      object.shouldCloseWindow(sender)
    }

    deinit {
      MainActor.assumeIsolated {
        object.windowDelegate = nil
      }
    }
  }
#endif
