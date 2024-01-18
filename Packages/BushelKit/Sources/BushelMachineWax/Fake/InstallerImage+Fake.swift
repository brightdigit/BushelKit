//
// InstallerImage+Fake.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension InstallerImage where Self == InstallerImageSub {
  static var sampleInstallerImage: Self { InstallerImageSub() }
}
