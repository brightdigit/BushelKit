//
// MachineSession.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
#endif

public protocol MachineSession {
  func begin() async throws
  var delegate: MachineSessionDelegate? { get set }
  #if canImport(SwiftUI)
    var view: AnyView { get }
  #endif
}
