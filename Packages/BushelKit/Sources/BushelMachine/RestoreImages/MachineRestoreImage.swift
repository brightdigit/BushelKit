//
// MachineRestoreImage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public struct MachineRestoreImage: Hashable, Identifiable {
  public let name: String
  public let id: UUID

  public let image: RestoreImage?

  public init(name: String, id: UUID = .init(), image: RestoreImage? = nil) {
    self.name = name
    self.id = id
    self.image = image
  }

  public init(context: RestoreImageContext) {
    let imageURL = context.library.url
      .appendingPathComponent(Paths.restoreImagesDirectoryName, isDirectory: true)
      .appendingPathComponent(context.id.uuidString)
      .appendingPathExtension("ipsw")

    let image = RestoreImage(metadata: context.metadata, location: .file(URLAccessor(url: imageURL)))
    self.init(name: context.name, id: context.id, image: image)
  }
}
