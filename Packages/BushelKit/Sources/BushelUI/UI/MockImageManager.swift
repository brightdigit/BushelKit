//
// RestoreImageDocumentView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct MockImageManager: ImageManager {
  func defaultName(for _: BushelMachine.ImageMetadata) -> String {
    "Windows Vista"
  }

  func containerFor(image _: Void, fileAccessor: BushelMachine.FileAccessor?) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(location: fileAccessor.map(ImageLocation.file) ?? .remote(.init(forHandle: BasicWindowOpenHandle.machine)), metadata: metadata)
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

  func validateSession(fromMachine machine: Machine) throws {
    
  }

  let metadata: BushelMachine.ImageMetadata
  func loadFromAccessor(_: BushelMachine.FileAccessor) async throws {}

  func imageContainer(vzRestoreImage _: Void) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(location: .file(URLAccessor(url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!)), metadata: metadata)
  }

  typealias ImageType = Void
}
