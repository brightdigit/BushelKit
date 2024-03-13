//
// SessionWindowDelegate.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit)
  import AppKit
  import BushelLogging
  import Foundation

  @MainActor
  class SessionWindowDelegate: NSObject, NSWindowDelegate, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .view
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var object: SessionObject!

    internal init(object: SessionObject) {
      self.object = object
    }

    func windowDidBecomeMain(_: Notification) {
      guard object.canStart, !object.hasIntialStarted else {
        return
      }

      object.hasIntialStarted = true
      object.begin { machine in
        try await machine.start()
      }
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
      Self.logger.debug("windowWillResize newSize \(newSize.debugDescription)")
      return newSize
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
      object.shouldCloseWindow(sender)
    }

    deinit {
      object.windowDelegate = nil
    }
  }
#endif
