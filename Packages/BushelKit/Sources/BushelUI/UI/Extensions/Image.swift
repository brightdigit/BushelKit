//
// Image.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

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
