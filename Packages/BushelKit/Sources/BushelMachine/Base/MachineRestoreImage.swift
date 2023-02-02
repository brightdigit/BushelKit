//
// MachineRestoreImage.swift
// Copyright (c) 2023 BrightDigit.
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

  public init(context: RestoreImageContext) {
    let imageURL = context.library.url
      .appendingPathComponent("Restore Images", isDirectory: true)
      .appendingPathComponent(context.id.uuidString)
      .appendingPathExtension("ipsw")

    let image = RestoreImage(metadata: context.metadata, location: .file(URLAccessor(url: imageURL)))
    self.init(name: context.name, id: context.id, image: image)
  }

  public let name: String
  public let id: UUID

  public let image: RestoreImage?
}
