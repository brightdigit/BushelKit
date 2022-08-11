//
// AnyImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers
#endif
public protocol AnyImageManager {
  init()
  func validateAt(_ url: URL) throws
  func load(from accessor: FileAccessor, using loader: RestoreImageLoader) async throws -> RestoreImage
  func session(fromMachine machine: Machine) throws -> MachineSession
  func buildMachine(_ machine: Machine, restoreImage: RestoreImage) async throws -> VirtualMachineFactory
  func defaultName(for metadata: ImageMetadata) -> String
  static var systemID: VMSystemID { get }
  #if canImport(UniformTypeIdentifiers)
    static var restoreImageContentTypes: [UTType] { get }
  #endif
}

public extension AnyImageManager {
  func buildMachine(_ machine: Machine, restoreImageFile: RestoreImageLibraryItemFile) async throws -> VirtualMachineFactory {
    guard let fileAccessor = restoreImageFile.fileAccessor else {
      throw MachineError.undefinedType("missing file accessor", nil)
    }

    let restoreImage = try await load(from: fileAccessor, using: FileRestoreImageLoader())
    return try await buildMachine(machine, restoreImage: restoreImage)
  }
}
