//
// MachineSession.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI
#endif

public protocol MachineSession: AnyObject {
  var state: MachineState { get }
  func begin() async throws
  func requestShutdown() throws
  var delegate: MachineSessionDelegate? { get set }

  func stop() async throws
  func pause() async throws
  func resume() async throws

  var allowedStateAction: StateAction { get }
  #if canImport(SwiftUI)
    var view: AnyView { get }
  #endif
}
