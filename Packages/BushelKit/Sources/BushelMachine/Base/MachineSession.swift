//
// MachineSession.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
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
