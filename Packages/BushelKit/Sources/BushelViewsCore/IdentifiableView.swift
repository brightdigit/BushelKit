//
// IdentifiableView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct IdentifiableView: Identifiable {
    let content: any View
    public let id: UUID

    internal init(_ content: any View, id: UUID = .init()) {
      self.content = content
      self.id = id
    }
  }
#endif
