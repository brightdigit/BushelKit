//
// InstallerImage+Fake.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

public extension InstallerImage where Self == InstallerImageSub {
  static var sampleInstallerImage: Self { InstallerImageSub() }
}
