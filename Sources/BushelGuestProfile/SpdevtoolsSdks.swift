//
//  SpdevtoolsSdks.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import Foundation

// MARK: - SpdevtoolsSdks

/// A struct representing the SDKs for various Apple platforms.
public struct SpdevtoolsSdks: Codable, Equatable, Sendable {
  /// The coding keys for the different Apple platforms.
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

  /// The DriverKit SDK.
  public let driverKit: DriverKit
  /// The iOS SDK.
  public let iOS: IOS
  /// The iOS Simulator SDK.
  public let iOSSimulator: IOS
  /// The macOS SDK.
  public let macOS: MACOS
  /// The tvOS SDK.
  public let tvOS: TvOS
  /// The tvOS Simulator SDK.
  public let tvOSSimulator: TvOS
  /// The watchOS SDK.
  public let watchOS: WatchOS
  /// The watchOS Simulator SDK.
  public let watchOSSimulator: WatchOS

  /// Initializes a new instance of `SpdevtoolsSdks`.
  /// - Parameters:
  ///   - driverKit: The DriverKit SDK.
  ///   - iOS: The iOS SDK.
  ///   - iOSSimulator: The iOS Simulator SDK.
  ///   - macOS: The macOS SDK.
  ///   - tvOS: The tvOS SDK.
  ///   - tvOSSimulator: The tvOS Simulator SDK.
  ///   - watchOS: The watchOS SDK.
  ///   - watchOSSimulator: The watchOS Simulator SDK.
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
