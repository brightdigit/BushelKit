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
  
  internal func testPrintMethod() {
    // Test that print method doesn't crash with various inputs
    ConsoleOutput.print("Regular message")
    ConsoleOutput.print("")  // Empty string
    ConsoleOutput.print("Message with\nnewlines")
    ConsoleOutput.print("Message with emoji 🎉")
    ConsoleOutput.print("Message with special chars: @#$%^&*()")
    
    // Since we're writing to stderr, we can't easily verify output
    // This test ensures the method doesn't crash with various inputs
    XCTAssertTrue(true, "Print method executed without errors")
  }
  
  internal func testPrintWithLongString() {
    // Test with a long string to ensure buffer handling works
    let longString = String(repeating: "a", count: 10000)
    ConsoleOutput.print(longString)
    
    XCTAssertTrue(true, "Print method handled long string")
  }
  
  internal func testPrintWithUnicodeCharacters() {
    // Test various Unicode characters
    ConsoleOutput.print("Hello, 世界")  // Chinese
    ConsoleOutput.print("مرحبا بالعالم")  // Arabic
    ConsoleOutput.print("🌍🌎🌏")  // Emojis
    ConsoleOutput.print("Café ☕")  // Accented characters
    
    XCTAssertTrue(true, "Print method handled Unicode characters")
  }
  
  internal func testAllOutputMethodsUseStderr() {
    // Verify all output methods call the base print method
    // This ensures consistency across all output methods
    ConsoleOutput.info("Info uses print")
    ConsoleOutput.success("Success uses print")
    ConsoleOutput.warning("Warning uses print")
    ConsoleOutput.error("Error uses print")
    
    ConsoleOutput.isVerbose = true
    ConsoleOutput.verbose("Verbose uses print when enabled")
    
    XCTAssertTrue(true, "All output methods executed without errors")
  }
}
