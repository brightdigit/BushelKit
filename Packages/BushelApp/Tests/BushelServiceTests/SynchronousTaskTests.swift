//
// SynchronousTaskTests.swift
// Copyright (c) 2024 BrightDigit.
//

@testable import BushelService
import XCTest

internal final class SynchronousTaskTests: XCTestCase {
  func testSuccessfulRun() throws {
    let startTime = Date()
    let timeout: DispatchTime = .now() + .seconds(5)
    try SynchronousTask(timeout: timeout) {
      try await Task.sleep(for: .seconds(2.0))
    }.run()
    let time = -startTime.timeIntervalSinceNow

    XCTAssertEqual(round(time), 2.0)
  }

  func testFailedRun() throws {
    var timeoutError: TimeoutError?
    let startTime = Date()
    let timeout: DispatchTime = .now() + .seconds(2)
    do {
      try SynchronousTask(timeout: timeout) {
        try await Task.sleep(for: .seconds(5.0))
      }.run()
      timeoutError = nil
    } catch let error as TimeoutError {
      timeoutError = error
    }
    let time = -startTime.timeIntervalSinceNow

    XCTAssertEqual(round(time), 2.0)
    XCTAssertEqual(timeoutError?.timeout, timeout)
  }
}
