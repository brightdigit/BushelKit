//
// MachineSessionDelegate.swift
// Copyright (c) 2022 BrightDigit.
//

public protocol MachineSessionDelegate: AnyObject {
  func session(_ session: MachineSession, didStopWithError error: Error)

  func session(
    _ session: MachineSession,
    device: MachineNetworkDevice,
    attachmentWasDisconnectedWithError error: Error
  )

  func sessionDidStop(_ session: MachineSession)
}
