//
// SpdevtoolsSdks.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpdevtoolsSdks

public struct SpdevtoolsSdks: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case driverKit = "DriverKit"
    case iOS
    case iOSSimulator = "iOS Simulator"
    case macOS
    case tvOS
    case tvOSSimulator = "tvOS Simulator"
    case watchOS
    case watchOSSimulator = "watchOS Simulator"
  }

  public let driverKit: DriverKit
  public let iOS: IOS
  public let iOSSimulator: IOS
  public let macOS: MACOS
  public let tvOS: TvOS
  public let tvOSSimulator: TvOS
  public let watchOS: WatchOS
  public let watchOSSimulator: WatchOS

  public init(
    driverKit: DriverKit,
    iOS: IOS,
    iOSSimulator: IOS,
    macOS: MACOS,
    tvOS: TvOS,
    tvOSSimulator: TvOS,
    watchOS: WatchOS,
    watchOSSimulator: WatchOS
  ) {
    self.driverKit = driverKit
    self.iOS = iOS
    self.iOSSimulator = iOSSimulator
    self.macOS = macOS
    self.tvOS = tvOS
    self.tvOSSimulator = tvOSSimulator
    self.watchOS = watchOS
    self.watchOSSimulator = watchOSSimulator
  }
}
