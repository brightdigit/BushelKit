//
// ByteCountFormatter.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

extension ByteCountFormatter {
  convenience init(_ modifications: @escaping (ByteCountFormatter) -> Void) {
    self.init()
    modifications(self)
  }

  convenience init(countStyle: CountStyle) {
    self.init {
      $0.countStyle = countStyle
    }
  }

  public static let memory: ByteCountFormatter = .init(countStyle: .memory)
  public static let file: ByteCountFormatter = .init(countStyle: .file)
}
