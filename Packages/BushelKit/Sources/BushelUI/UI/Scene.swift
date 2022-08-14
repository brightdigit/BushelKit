//
// Scene.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
//

import SwiftUI

extension Scene {
  func windowsHandle<HandleType: StaticConditionalHandle>(_ handle: HandleType.Type) -> some Scene {
    handlesExternalEvents(matching: .init(handle.conditions))
  }

  func windowsHandle<HandleType: InstanceConditionalHandle>(_ handle: HandleType) -> some Scene {
    handlesExternalEvents(matching: .init(handle.conditions))
  }

  public func disableResizability() -> some Scene {
    #if swift(>=5.7)
      if #available(macOS 13.0, *) {
        return self.windowResizability(.contentSize)
      } else {
        return self
      }
    #else
      return self
    #endif
  }
}
