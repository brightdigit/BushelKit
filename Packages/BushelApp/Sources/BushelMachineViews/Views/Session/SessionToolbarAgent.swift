//
// SessionToolbarAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

@MainActor
internal protocol SessionToolbarAgent {
  var canStart: Bool { get }

  var canStop: Bool { get }

  var canPause: Bool { get }

  var canResume: Bool { get }

  var canPressPowerButton: Bool { get }

  func start()
  func pause()
  func resume()

  func snapshot(_ request: SnapshotRequest, options: SnapshotOptions)
  func pressPowerButton()
}
