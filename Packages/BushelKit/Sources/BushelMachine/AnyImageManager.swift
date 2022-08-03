//
// AnyImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
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
  static var systemID: VMSystemID { get }
  #if canImport(UniformTypeIdentifiers)
    static var restoreImageContentTypes: [UTType] { get }
  #endif
}
