//
// MockSystem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelHub
import BushelMacOSCore
import BushelSystem
import Foundation

struct MockSystem: System {
  var hubs: [Hub] {
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
              fileExtension: "ipsw",
              vmSystem: .macOS
            ),
            url: .init(
              "http://localhost:8080/UniversalMac_14.0_23A5337a_Restore.ipsw"
            )
          )
        ]
      }
    ]
  }
}
