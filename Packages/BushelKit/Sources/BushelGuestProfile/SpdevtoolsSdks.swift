//
//  SpdevtoolsSdks.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

// MARK: - SpdevtoolsSdks

public struct SpdevtoolsSdks: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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
