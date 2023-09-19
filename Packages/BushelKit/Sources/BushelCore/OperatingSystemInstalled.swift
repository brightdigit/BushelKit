//
// OperatingSystemInstalled.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol OperatingSystemInstalled {
  var buildVersion: String? { get }
  var operatingSystemVersion: OperatingSystemVersion { get }
}
