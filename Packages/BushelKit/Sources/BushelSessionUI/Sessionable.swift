//
// Sessionable.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  public protocol Sessionable {
    associatedtype Content: View
    func view() -> Content
  }

  public extension Sessionable {
    func anyView() -> AnyView {
      .init(self.view())
    }
  }
#endif
