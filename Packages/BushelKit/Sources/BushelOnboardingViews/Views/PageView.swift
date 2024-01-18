//
// PageView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import SwiftUI
  public extension PageView {
    init(
      onDismiss: (() -> Void)? = nil,
      @PageItemBuilder items: () -> [any View]
    ) {
      let pages = items().map { IdentifiableView($0) }
      self.init(pages: pages, onDismiss: onDismiss)
    }
  }
#endif
