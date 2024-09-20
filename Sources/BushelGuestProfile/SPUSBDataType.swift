//
//  SPUSBDataType.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public import Foundation

// MARK: - SPUSBDataType

public struct SPUSBDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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
  public init(
    items: [SPUSBDataTypeItem],
    name: String,
    hostController: String,
    pciDevice: String,
    pciRevision: String,
    pciVendor: String
  ) {
    self.items = items
    self.name = name
    self.hostController = hostController
    self.pciDevice = pciDevice
    self.pciRevision = pciRevision
    self.pciVendor = pciVendor
  }
}
