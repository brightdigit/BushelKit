//
// MockImageManager.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable all
#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import BushelVirtualization
  import SwiftUI
  import UniformTypeIdentifiers

  struct MockImageManager: ImageManager {
    struct MockImageContainer: ImageContainer {
      var location: BushelVirtualization.ImageLocation?

      var metadata: ImageMetadata
    }

    func containerFor(image _: Void, fileAccessor: BushelVirtualization.FileAccessor?) async throws -> BushelVirtualization.ImageContainer {
      MockImageContainer(location: .file(fileAccessor!), metadata: metadata)
    }

    func imageNameFor(operatingSystemVersion _: OperatingSystemVersion) -> String? {
      "OSVersions/Big Sur"
    }

    var supportedSystems: [OperatingSystemDetails.System] {
      []
    }

    func codeNameFor(operatingSystemVersion: OperatingSystemVersion) -> String {
      operatingSystemVersion.majorVersion.description
    }

    func defaultSpecifications() -> MachineSpecification {
      .init(
        cpuCount: 1,
        memorySize: UInt64(64 * 1024 * 1024 * 1024),
        storageDevices: [.init(id: .init(), label: "mock OS", size: UInt64(64 * 1024 * 1024 * 1024))],
        networkConfigurations: [.init(attachment: .nat)],
        graphicsConfigurations: [
          .init(displays: [.init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)])
        ]
      )
    }

//    func defaultName(for _: ImageMetadata) -> String {
//      "Windows Vista"
//    }

//    func containerFor(image _: Void, fileAccessor: FileAccessor?) async throws -> ImageContainer {
//      MockImageContainer(
//        location: fileAccessor.map(ImageLocation.file) ?? .remote(.init(forHandle: BasicWindowOpenHandle.remoteSources)),
//        metadata: metadata
//      )
//    }

    func restoreImage(from _: FileAccessor) async throws {
      fatalError()
    }

    func buildMachine(_: Machine, restoreImage _: Void) -> VirtualMachineFactory {
      fatalError()
    }

    internal init(metadata: ImageMetadata) {
      self.metadata = metadata
    }

    init() {
      metadata = .Previews.monterey
    }

    func session(fromMachine _: Machine) throws -> MachineSession {
      fatalError()
    }

    static let systemID: VMSystemID = "mock"

    static let restoreImageContentTypes: [UTType] = []

    func validateSession(fromMachine _: Machine) throws {}

    let metadata: ImageMetadata
    func loadFromAccessor(_: FileAccessor) async throws {}

    typealias ImageType = Void
  }
#endif
