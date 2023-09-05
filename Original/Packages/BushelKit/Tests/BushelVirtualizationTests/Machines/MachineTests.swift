//
// MachineTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelVirtualization
import BushelWax
import XCTest

struct MockFileVersion: FileVersion {
  static let typeID: String = "mock"

  let id: Data
  let url: URL

  let isDiscardable: Bool

  let modificationDate: Date?

  static func fetchVersion(at _: URL, withID _: Data) throws -> BushelVirtualization.FileVersion? {
    fatalError()
  }

  func save(to _: URL) async throws {
    fatalError()
  }

  func getIdentifier() throws -> Data {
    id
  }

  static func createVersion(at url: URL, withContentsOf contentsURL: URL, isDiscardable: Bool, byMoving: Bool) throws -> BushelVirtualization.FileVersion {
    guard let result = self.result else {
      preconditionFailure()
    }

    passedCreateVersionArguments = .init(url: url, contentsURL: contentsURL, isDiscardable: isDiscardable, byMoving: byMoving)
    self.result = nil
    return try result.get()
  }

  static var result: Result<MockFileVersion, Error>?
  static var passedCreateVersionArguments: CreateVersionArguments?

  struct CreateVersionArguments: Equatable {
    let url: URL
    let contentsURL: URL
    let isDiscardable: Bool
    let byMoving: Bool
  }

  static func prepare(forResult result: Result<MockFileVersion, Error>) {
    passedCreateVersionArguments = nil
    self.result = result
  }

  static func reset() {}
}

final class MachineTests: XCTestCase {
  func testAddSnapshot() throws {
    let mockFileVersion = MockFileVersion(
      id: .random(),
      url: .randomFile(),
      isDiscardable: .random(),
      modificationDate: .randomPast(asFarBackAs: 10000.0)
    )

    let expected = try MachineSnapshot(fileVersion: mockFileVersion)

    MockFileVersion.prepare(forResult: .success(mockFileVersion))

    let machineURL: URL = .randomFile()

    var machine = Machine.preview
    machine.rootFileAccessor = URLAccessor(url: machineURL)
    machine.snapshots = []

    try machine.addSnapshot(using: MockFileVersion.self)

    let actual = machine.snapshots.first
    XCTAssertEqual(actual, expected)
    XCTAssertEqual(MockFileVersion.passedCreateVersionArguments, .init(url: machineURL, contentsURL: machineURL, isDiscardable: mockFileVersion.isDiscardable, byMoving: false))
  }
}
