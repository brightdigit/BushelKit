//
// MachineRestoreImage.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Foundation

public struct MachineRestoreImage: Hashable, Identifiable {
  public init(file: RestoreImageLibraryItemFile) {
    id = file.id
    name = file.name
    image = RestoreImage(imageContainer: file)
  }

  public init(name: String, id: String, image: RestoreImage? = nil) {
    self.name = name
    self.id = id.data(using: .utf8)!
    self.image = image
  }

  public let name: String
  public let id: Data

  public let image: RestoreImage?
}
