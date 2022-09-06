//
// Image.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import Foundation
  import SwiftUI

  extension Image {
    init(operatingSystemVersion: OperatingSystemVersion) {
      let codeName = OperatingSystemCodeName(operatingSystemVersion: operatingSystemVersion)
      let imageName = codeName?.name
      self.init(imageName ?? "Big Sur")
    }
  }
#endif
