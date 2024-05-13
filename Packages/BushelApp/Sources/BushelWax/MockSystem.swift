//
// MockSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelMacOSCore
import BushelSystem
import Foundation

public struct MockSystem: System {
  public var hubs: [Hub] {
    [
      Hub(title: "Totally Fake", id: "fake", count: 1) {
        [
          HubImage(
            title: "local download",
            metadata: .init(
              isImageSupported: true,
              buildVersion: "@!#",
              operatingSystemVersion: .init(majorVersion: 1, minorVersion: 1, patchVersion: 0),
              contentLength: 123,
              lastModified: .now,
              fileExtension: MacOSVirtualization.ipswFileExtension,
              vmSystemID: .macOS
            ),
            url: .init(
              "http://localhost:8080/6679D692-1B85-4788-B582-80E3337E53C5.ipsw"
            )
          )
        ]
      }
    ]
  }

  public init() {}
}
