//
// SessionWindowDelegate.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AppKit)
  import AppKit
  import BushelLogging
  import Foundation

  class SessionWindowDelegate: NSObject, NSWindowDelegate, LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .view
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var object: SessionObject!

    internal init(object: SessionObject) {
      self.object = object
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
