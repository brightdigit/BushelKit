//
// MockImageManager.swift
// Copyright (c) 2022 BrightDigit.
//

// swiftlint:disable all
#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  struct MockImageManager: ImageManager {
    func defaultName(for _: BushelMachine.ImageMetadata) -> String {
      "Windows Vista"
    }

    func containerFor(image _: Void, fileAccessor: BushelMachine.FileAccessor?) async throws -> BushelMachine.ImageContainer {
      MockImageContainer(
        location: fileAccessor.map(ImageLocation.file) ?? .remote(.init(forHandle: BasicWindowOpenHandle.remoteSources)),
        metadata: metadata
      )
    }

    func restoreImage(from _: BushelMachine.FileAccessor) async throws {
      fatalError()
    }

    func buildMachine(_: BushelMachine.Machine, restoreImage _: Void) -> BushelMachine.VirtualMachineFactory {
      fatalError()
    }

    internal init(metadata: ImageMetadata) {
      self.metadata = metadata
    }

    init() {
      fatalError()
    }

    func session(fromMachine _: BushelMachine.Machine) throws -> BushelMachine.MachineSession {
      fatalError()
    }

    static let systemID: VMSystemID = "mock"

    static let restoreImageContentTypes: [UTType] = []

    func validateSession(fromMachine _: Machine) throws {}

    let metadata: BushelMachine.ImageMetadata
    func loadFromAccessor(_: BushelMachine.FileAccessor) async throws {}

    typealias ImageType = Void
  }
#endif
