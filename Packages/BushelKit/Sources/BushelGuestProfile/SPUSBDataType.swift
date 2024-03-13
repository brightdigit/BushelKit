//
// SPUSBDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPUSBDataType

public struct SPUSBDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case items = "_items"
    case name = "_name"
    case hostController = "host_controller"
    case pciDevice = "pci_device"
    case pciRevision = "pci_revision"
    case pciVendor = "pci_vendor"
  }

  public let items: [SPUSBDataTypeItem]
  public let name: String
  public let hostController: String
  public let pciDevice: String
  public let pciRevision: String
  public let pciVendor: String

  // swiftlint:disable:next line_length
  public init(items: [SPUSBDataTypeItem], name: String, hostController: String, pciDevice: String, pciRevision: String, pciVendor: String) {
    self.items = items
    self.name = name
    self.hostController = hostController
    self.pciDevice = pciDevice
    self.pciRevision = pciRevision
    self.pciVendor = pciVendor
  }
}
