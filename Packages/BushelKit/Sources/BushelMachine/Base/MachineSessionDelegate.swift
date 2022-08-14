//
// MachineSessionDelegate.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

public protocol MachineSessionDelegate: AnyObject {
  func session(_ session: MachineSession, didStopWithError error: Error)

  func session(_ session: MachineSession, device: MachineNetworkDevice, attachmentWasDisconnectedWithError error: Error)

  func sessionDidStop(_ session: MachineSession)
}
