//
// PageView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import RadiantKit

  public import SwiftUI

  extension PageView {
    public init(
      onDismiss: (@Sendable (DismissParameters) -> Void)? = nil,
      @PageItemBuilder items: () -> [any View]
    ) {
      let pages = items().enumerated().map { IdentifiableView($0.element, id: $0.offset) }
      self.init(pages: pages, onDismiss: onDismiss)
    }
  }
#endif
