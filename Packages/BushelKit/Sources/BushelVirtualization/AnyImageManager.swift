//
// AnyImageManager.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers
#endif
public protocol AnyImageManager {
  static var systemID: VMSystemID { get }
  #if canImport(UniformTypeIdentifiers)
    static var restoreImageContentTypes: [UTType] { get }
  #endif
  var supportedSystems: [OperatingSystemDetails.System] { get }
  init()
  func validateSession(fromMachine machine: Machine) throws
  func load(
    from accessor: FileAccessor,
    using loader: RestoreImageLoader
  ) async throws -> RestoreImage
  func session(fromMachine machine: Machine) throws -> MachineSession
  func buildMachine(
    _ machine: Machine,
    restoreImage: RestoreImage
  ) async throws -> VirtualMachineFactory
  func defaultSpecifications() -> MachineSpecification
  func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String
  func imageNameFor(operatingSystemVersion: OperatingSystemVersion) -> String?
}

public extension AnyImageManager {
  func buildMachine(
    _ machine: Machine,
    restoreImageFile: RestoreImageLibraryItemFile
  ) async throws -> VirtualMachineFactory {
    guard let fileAccessor = restoreImageFile.fileAccessor else {
      throw ManagerError.undefinedType("missing file accessor", nil)
    }

    let restoreImage = try await load(from: fileAccessor, using: FileRestoreImageLoader())
    return try await buildMachine(machine, restoreImage: restoreImage)
  }

  func restoreLibraryItem(_ newImageURL: URL) async throws -> RestoreImageLibraryItemFile {
    let accessor = URLAccessor(url: newImageURL)
    let restoreImage = try await load(from: accessor, using: FileRestoreImageLoader())
    guard let restoreImageFile = RestoreImageLibraryItemFile(loadFromImage: restoreImage) else {
      throw ManagerError.undefinedType("invalid restore image", restoreImage)
    }
    return restoreImageFile
  }

  func defaultName(for metadata: ImageMetadata) -> String {
    codeNameFor(operatingSystemVersion: metadata.operatingSystemVersion)
  }
}
