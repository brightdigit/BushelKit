//
// LocalizedID.swift
// Copyright (c) 2024 BrightDigit.
//

public protocol LocalizedID {
  var keyValue: String { get }
}

#if canImport(SwiftUI)
  public import SwiftUI

  extension LocalizedID {
    public var key: LocalizedStringKey {
      LocalizedStringID.assert()
      return LocalizedStringKey(keyValue)
    }
  }
#endif
