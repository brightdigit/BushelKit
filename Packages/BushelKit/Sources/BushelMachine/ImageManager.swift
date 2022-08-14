//
// ImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import Foundation

public extension ImageManager {
  func load(from accessor: FileAccessor, using loader: RestoreImageLoader) async throws -> RestoreImage {
    try await loader.load(from: accessor, using: self)
  }

  func buildMachine(_ machine: Machine, restoreImage: RestoreImage) async throws -> VirtualMachineFactory {
    guard case let .file(fileAccessor) = restoreImage.location else {
      throw MachineError.undefinedType("remote restore Image", restoreImage.location)
    }

    let image = try await self.restoreImage(from: fileAccessor)
    return try buildMachine(machine, restoreImage: image)
  }
}

public protocol ImageManager: AnyImageManager {
  associatedtype ImageType
  func loadFromAccessor(_ accessor: FileAccessor) async throws -> ImageType
  func containerFor(image: ImageType, fileAccessor: FileAccessor?) async throws -> ImageContainer
  func buildMachine(_ machine: Machine, restoreImage: ImageType) throws -> VirtualMachineFactory
  func restoreImage(from fileAccessor: FileAccessor) async throws -> ImageType
}
