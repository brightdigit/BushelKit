//
// ACPower.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - ACPower

public struct ACPower: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case currentPowerSource = "Current Power Source"
    case diskSleepTimer = "Disk Sleep Timer"
    case displaySleepTimer = "Display Sleep Timer"
    case sleepOnPowerButton = "Sleep On Power Button"
    case systemSleepTimer = "System Sleep Timer"
  }

  public let currentPowerSource: String
  public let diskSleepTimer: Int
  public let displaySleepTimer: Int
  public let sleepOnPowerButton: String
  public let systemSleepTimer: Int

  public init(
    currentPowerSource: String,
    diskSleepTimer: Int,
    displaySleepTimer: Int,
    sleepOnPowerButton: String,
    systemSleepTimer: Int
  ) {
    self.currentPowerSource = currentPowerSource
    self.diskSleepTimer = diskSleepTimer
    self.displaySleepTimer = displaySleepTimer
    self.sleepOnPowerButton = sleepOnPowerButton
    self.systemSleepTimer = systemSleepTimer
  }
}
