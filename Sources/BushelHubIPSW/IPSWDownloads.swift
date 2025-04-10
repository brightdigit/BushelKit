//
//  IPSWDownloads.swift
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

public import BushelHub
public import BushelLogging
internal import Foundation
internal import OpenAPIURLSession

@_exported public import struct IPSWDownloads.IPSWDownloads

extension IPSWDownloads: Loggable {
  private static let title = "IPSW Downloads"
  private static let hubID = "ipsw-downloads"
  private static let virtualMacID = "VirtualMac2,1"
  private static let lastCountUserDefaultsKey = "IPSWDownloadsImageLastCount"

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
    }
    set {
      assert(newValue != nil)
      let userDefaults = UserDefaults(suiteName: Bundle.suiteName)
      assert(userDefaults != nil)
      userDefaults?.set(newValue, forKey: lastCountUserDefaultsKey)
    }
  }

  @Sendable
  public static func hubs() -> [Hub] {
    [
      .init(
        title: title,
        id: hubID,
        systemID: .macOS,
        signaturePriority: .never,
        count: lastCount,
        self.hubImages
      )
    ]
  }

  @Sendable
  public static func hubImages() async throws -> [HubImage] {
    let client = IPSWDownloads(transport: URLSessionTransport())
    let firmwares = try await client.device(withIdentifier: virtualMacID, type: .ipsw).firmwares
    self.lastCount = firmwares.count
    return firmwares.tryCompactMap(HubImage.init)
  }
}
