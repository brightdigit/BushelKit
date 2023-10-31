//
// SessionToolbarAgent.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

protocol SessionToolbarAgent {
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
