//
// MachineContext.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct MachineContext: Codable, Hashable {
  public init(url: URL, id: UUID, restoreImageID: UUID, operatingSystem: OperatingSystemDetails) {
    self.url = url
    self.id = id
    self.restoreImageID = restoreImageID
    self.operatingSystem = operatingSystem
  }

  public let url: URL
  public let id: UUID
  public var restoreImageID: UUID
  public var operatingSystem: OperatingSystemDetails

  public init(machine: Machine) throws {
    guard let fileAccessor = machine.rootFileAccessor else {
      throw MachineError.undefinedType("missing rootFileAccessor", machine)
    }
    guard let restoreImageID = machine.restoreImage?.id else {
      throw MachineError.undefinedType("missing restoreImage", machine)
    }
    guard let operatingSystem = machine.operatingSystem else {
      throw MachineError.undefinedType("missing operatingSystem", machine)
    }
    let url = try fileAccessor.getURL(createIfNotExists: false)

    self.init(
      url: url,
      id: machine.id,
      restoreImageID: restoreImageID,
      operatingSystem: operatingSystem
    )
  }
}
