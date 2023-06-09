//
// MachineSession.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
#endif

public protocol MachineSession: AnyObject {
  var state: MachineState { get }
  var delegate: MachineSessionDelegate? { get set }
  var allowedStateAction: StateAction { get }
  #if canImport(SwiftUI)
    var view: AnyView { get }
  #endif

  func begin() async throws
  func requestShutdown() throws
  func stop() async throws
  func pause() async throws
  func resume() async throws
}
