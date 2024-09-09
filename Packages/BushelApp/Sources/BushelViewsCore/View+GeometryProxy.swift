//
// View+GeometryProxy.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation

  public import SwiftUI

  extension View {
    public func onGeometry(_ action: @escaping (GeometryProxy) -> Void) -> some View {
      self.overlay {
        GeometryReader(content: { geometry in
          Color.clear.onAppear(perform: {
            action(geometry)
          })
        })
      }
    }
  }
#endif
