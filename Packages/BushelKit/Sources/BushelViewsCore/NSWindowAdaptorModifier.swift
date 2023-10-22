//
// NSWindowAdaptorModifier.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
#if canImport(SwiftUI)
  import SwiftUI

  #if canImport(AppKit)
    import AppKit

    // swiftlint:disable strict_fileprivate
    private struct NSWindowAdaptorHostingView: NSViewRepresentable {
      private var callback: (NSWindow?) -> Void

      fileprivate init(callback: @escaping (NSWindow?) -> Void) {
        self.callback = callback
      }

      fileprivate func makeNSView(context _: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
          self.callback(view?.window)
        }
        view.setFrameSize(.zero)
        view.isHidden = true
        view.frame = CGRect.zero
        return view
      }

      fileprivate func updateNSView(_: NSView, context _: Context) {}
    }

    private struct NSWindowAdaptorModifier: ViewModifier {
      private var callback: (NSWindow?) -> Void

      fileprivate init(callback: @escaping (NSWindow?) -> Void) {
        self.callback = callback
      }

      fileprivate func body(content: Content) -> some View {
        content
          .overlay(
            NSWindowAdaptorHostingView(callback: callback)
              .frame(width: 0, height: 0)
          )
      }
    }

    public extension View {
      func nsWindowAdaptor(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.modifier(NSWindowAdaptorModifier(callback: callback))
      }
    }
  #else
    public extension View {
      func nsWindowAdaptor(_: @escaping (Any?) -> Void) -> some View {
        self
      }
    }
  #endif
#endif
