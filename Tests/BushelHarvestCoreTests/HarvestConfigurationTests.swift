//
//  HarvestConfigurationTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Testing

@testable import BushelHarvestCore

@Suite("Harvest Configuration Tests")
internal struct HarvestConfigurationTests {
  @Test("Default port matches the documented value")
  internal func defaultPort() {
    #expect(HarvestConfiguration.defaultPort == 8_080)
  }

  @Test("Maximum message length is 16 MiB")
  internal func maxMessageLength() {
    #expect(HarvestConfiguration.maxMessageLength == 16 * 1_024 * 1_024)
  }

  @Test("I/O timeout is a positive number of seconds")
  internal func ioTimeout() {
    #expect(HarvestConfiguration.ioTimeoutSeconds == 30)
    #expect(HarvestConfiguration.ioTimeoutSeconds > 0)
  }
}
