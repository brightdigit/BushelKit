//
// Image.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import Foundation
  import SwiftUI

  extension Image {
    init(system: VMSystemID, operatingSystemVersion: OperatingSystemVersion) {
      if let name = AnyImageManagers.imageManager(forSystem: system)?.imageNameFor(operatingSystemVersion: operatingSystemVersion) {
        self.init(name, bundle: .module)
      } else if let icon = Icons.California.allCases.randomElement() {
        self.init(icon: icon)
      } else {
        preconditionFailure()
      }
    }

    init(operatingSystemDetails: OperatingSystemDetails) {
      if let name = AnyImageManagers.imageManager(forOperatingSystem: operatingSystemDetails.type)?.imageNameFor(operatingSystemVersion: operatingSystemDetails.version) {
        self.init(name, bundle: .module)
      } else if let icon = Icons.California.allCases.randomElement() {
        self.init(icon: icon)
      } else {
        preconditionFailure()
      }
    }
  }
#endif
