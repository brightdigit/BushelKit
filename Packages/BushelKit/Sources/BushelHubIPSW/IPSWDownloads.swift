//
// IPSWDownloads.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLogging
import Foundation
import OpenAPIURLSession

@_exported import struct IPSWDownloads.IPSWDownloads

extension IPSWDownloads: Loggable {
  static let title = "IPSW Downloads"
  static let hubID = "ipsw-downloads"
  static let virtualMacID = "VirtualMac2,1"
  static let lastCountUserDefaultsKey = "IPSWDownloadsImageLastCount"

  public static let loggingCategory: BushelLogging.Category = .hub

  public static var lastCount: Int? {
    get {
      let userDefaults = UserDefaults(suiteName: Bundle.suiteName)
      guard userDefaults?.object(forKey: lastCountUserDefaultsKey) != nil else {
        return nil
      }
      let value = userDefaults?.integer(forKey: lastCountUserDefaultsKey)
      assert(value != 0)
      return value.flatMap {
        $0 == 0 ? nil : $0
      }
    } set {
      assert(newValue != nil)
      let userDefaults = UserDefaults(suiteName: Bundle.suiteName)
      assert(userDefaults != nil)
      userDefaults?.set(newValue, forKey: lastCountUserDefaultsKey)
    }
  }

  public static func hubs() -> [Hub] {
    [
      .init(title: title, id: hubID, count: lastCount, self.hubImages)
    ]
  }

  public static func hubImages() async throws -> [HubImage] {
    let client = IPSWDownloads(transport: URLSessionTransport())
    let firmwares = try await client.device(withIdentifier: virtualMacID, type: .ipsw).firmwares
    self.lastCount = firmwares.count
    return firmwares.tryCompactMap(HubImage.init)
  }
}
