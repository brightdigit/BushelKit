//
// Scene.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  extension Scene {
    func windowsHandle<HandleType: StaticConditionalHandle>(_ handle: HandleType.Type) -> some Scene {
      handlesExternalEvents(matching: .init(handle.conditions))
    }

    func windowsHandle<HandleType: InstanceConditionalHandle>(_ handle: HandleType) -> some Scene {
      handlesExternalEvents(matching: .init(handle.conditions))
    }

    @available(*, deprecated)
    func attemptSingleWindowFor<Content: View>(_ title: String, id: String, @ViewBuilder content: @escaping () -> Content) -> some Scene {
      #if swift(>=5.7)
        if #available(macOS 13.0, *) {
          return Window(title, id: id) {
            content()
          }
        } else {
          return WindowGroup(title, id: id) {
            content()
          }
        }
      #else
        return WindowGroup(title, id: id) {
          content()
        }
      #endif
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
#endif
