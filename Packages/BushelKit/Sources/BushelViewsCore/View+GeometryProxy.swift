//
// View+GeometryProxy.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  public extension View {
    func onGeometry(_ action: @escaping (GeometryProxy) -> Void) -> some View {
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
