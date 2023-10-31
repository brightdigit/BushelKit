//
// LocalizedID.swift
// Copyright (c) 2023 BrightDigit.
//

public protocol LocalizedID {
  var keyValue: String { get }
}

#if canImport(SwiftUI)
  import SwiftUI

  public extension LocalizedID {
    var key: LocalizedStringKey {
      LocalizedStringID.assert()
      return LocalizedStringKey(keyValue)
    }
  }
#endif
