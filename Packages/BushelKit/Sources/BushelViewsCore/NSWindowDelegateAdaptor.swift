//
// NSWindowDelegateAdaptor.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import SwiftUI

  class NSWindowDelegateAdaptor: NSObject, NSWindowDelegate {
    internal init(onWindowShouldClose: ((NSWindow) -> Bool)?) {
      self.onWindowShouldClose = onWindowShouldClose
    }

    let onWindowShouldClose: ((NSWindow) -> Bool)?

    func windowShouldClose(_ sender: NSWindow) -> Bool {
      onWindowShouldClose?(sender) ?? true
    }
  }

  private struct NSWindowDelegateAdaptorModifier: ViewModifier {
    @Binding var binding: NSWindowDelegate?
    // swiftlint:disable:next weak_delegate
    let delegate: NSWindowDelegate

    internal init(binding: Binding<NSWindowDelegate?>, delegate: @autoclosure () -> NSWindowDelegate) {
      self._binding = binding
      self.delegate = binding.wrappedValue ?? delegate()

      self.binding = self.delegate
    }

    func body(content: Content) -> some View {
      content.nsWindowAdaptor { window in
        assert(!self.delegate.isEqual(window?.delegate))
        assert(window != nil)
        window?.delegate = delegate
      }
    }
  }

  extension View {
    func nsWindowDelegateAdaptor(_ binding: Binding<NSWindowDelegate?>, _ delegate: @autoclosure () -> NSWindowDelegate) -> some View {
      self.modifier(NSWindowDelegateAdaptorModifier(binding: binding, delegate: delegate()))
    }

    public func onCloseButton(_ delegate: Binding<NSWindowDelegate?>, _ closure: @escaping (NSWindow) -> Bool) -> some View {
      self.nsWindowDelegateAdaptor(delegate, NSWindowDelegateAdaptor(onWindowShouldClose: closure))
    }
  }
#endif
