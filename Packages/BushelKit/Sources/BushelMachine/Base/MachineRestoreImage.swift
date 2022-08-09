//
// MachineRestoreImage.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import Foundation

public struct MachineRestoreImage: Hashable, Identifiable {
  public init(file: RestoreImageLibraryItemFile) {
    id = file.id
    name = file.name
    image = RestoreImage(imageContainer: file)
  }

  public init(name: String, id: UUID = .init(), image: RestoreImage? = nil) {
    self.name = name
    self.id = id
    self.image = image
  }

  public let name: String
  public let id: UUID

  public let image: RestoreImage?
}
