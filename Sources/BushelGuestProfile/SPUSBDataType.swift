//
//  SPUSBDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

/// Represents a USB data type,
/// including its items, name, host controller, PCI device, PCI revision, and PCI vendor.
public struct SPUSBDataType: Codable, Equatable, Sendable {
  /// The keys used for encoding and decoding the data type.
  public enum CodingKeys: String, CodingKey {
    case items = "_items"
    case name = "_name"
    case hostController = "host_controller"
    case pciDevice = "pci_device"
    case pciRevision = "pci_revision"
    case pciVendor = "pci_vendor"
  }

  /// The array of `SPUSBDataTypeItem` objects associated with this data type.
  public let items: [SPUSBDataTypeItem]
  /// The name of the data type.
  public let name: String
  /// The host controller for the USB data type.
  public let hostController: String
  /// The PCI device for the USB data type.
  public let pciDevice: String
  /// The PCI revision for the USB data type.
  public let pciRevision: String
  /// The PCI vendor for the USB data type.
  public let pciVendor: String

  /// Initializes a new instance of `SPUSBDataType`.
  ///
  /// - Parameters:
  ///   - items: The array of `SPUSBDataTypeItem` objects associated with this data type.
  ///   - name: The name of the data type.
  ///   - hostController: The host controller for the USB data type.
  ///   - pciDevice: The PCI device for the USB data type.
  ///   - pciRevision: The PCI revision for the USB data type.
  ///   - pciVendor: The PCI vendor for the USB data type.
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
