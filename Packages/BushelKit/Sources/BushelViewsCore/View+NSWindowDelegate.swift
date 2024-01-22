//
// View+NSWindowDelegate.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import SwiftUI

  private struct NSWindowDelegateAdaptorModifier: ViewModifier {
    #warning("Modifying state during view update, this will cause undefined behavior.")
    @Binding var binding: (any NSWindowDelegate)?
    // swiftlint:disable:next weak_delegate
    let delegate: any NSWindowDelegate

    init(
      binding: Binding<(any NSWindowDelegate)?>,
      delegate: @autoclosure () -> any NSWindowDelegate
    ) {
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

  public extension View {
    func nsWindowDelegateAdaptor(
      _ binding: Binding<(any NSWindowDelegate)?>,
      _ delegate: @autoclosure () -> any NSWindowDelegate
    ) -> some View {
      self.modifier(
        NSWindowDelegateAdaptorModifier(
          binding: binding,
          delegate: delegate()
        )
      )
    }
  }
#endif
