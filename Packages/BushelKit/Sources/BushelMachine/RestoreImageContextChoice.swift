//
// RestoreImageContextChoice.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation
public enum RestoreImageContextChoice: Identifiable, Hashable {
  case image(MachineRestoreImage)
  case none

  static let noneID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
  public var id: UUID {
    guard case let .image(restoreImageContext) = self else {
      return Self.noneID
    }

    return restoreImageContext.id
  }

  public init(context: RestoreImageContext) {
    self = .image(MachineRestoreImage(context: context))
  }
}

public extension RestoreImageContextChoice {
  var machineRestoreImage: MachineRestoreImage? {
    guard case let .image(restoreImageContext) = self else {
      return nil
    }

    return restoreImageContext
  }

  var name: String? {
    machineRestoreImage?.name
  }
}
