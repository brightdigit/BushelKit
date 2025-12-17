//
//  ConsoleOutputTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest

@testable import BushelUtilities

internal final class ConsoleOutputTests: XCTestCase {
  private var originalVerboseState: Bool = false

  override internal func setUp() {
    super.setUp()
    // Save original state
    originalVerboseState = ConsoleOutput.isVerbose
  }

  override internal func tearDown() {
    // Restore original state
    ConsoleOutput.isVerbose = originalVerboseState
    super.tearDown()
  }

  internal func testVerboseModeEnabled() {
    ConsoleOutput.isVerbose = true

    // We can't easily test print output without redirecting stdout
    // This test mainly verifies the code doesn't crash
    ConsoleOutput.verbose("Test message")
    ConsoleOutput.info("Info message")
    ConsoleOutput.success("Success message")
    ConsoleOutput.warning("Warning message")
    ConsoleOutput.error("Error message")

    XCTAssertTrue(ConsoleOutput.isVerbose)
  }

  internal func testVerboseModeDisabled() {
    ConsoleOutput.isVerbose = false

    // Verbose should not print, but shouldn't crash
    ConsoleOutput.verbose("Should not print")

    // Other methods should still work
    ConsoleOutput.info("Info")

    XCTAssertFalse(ConsoleOutput.isVerbose)
  }

  internal func testSendable() {
    // Verify thread-safe access (compile-time check mostly)
    Task {
      let verbose = ConsoleOutput.isVerbose
      XCTAssertNotNil(verbose)
    }
  }
}
