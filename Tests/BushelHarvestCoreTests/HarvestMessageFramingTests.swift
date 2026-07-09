//
//  HarvestMessageFramingTests.swift
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

import Foundation
import Testing

@testable import BushelHarvestCore

#if canImport(Darwin)
  import Darwin
#endif

@Suite("Harvest Message Framing Tests")
internal struct HarvestMessageFramingTests {
  @Test("frame prepends a 4-byte big-endian length prefix")
  internal func framePrependsBigEndianLength() {
    let body = Data([0x0A, 0x0B, 0x0C])
    let framed = HarvestMessageFraming.frame(body)

    #expect(framed.count == body.count + 4)
    // 3 bytes → 0x00000003 big-endian.
    #expect(Array(framed.prefix(4)) == [0x00, 0x00, 0x00, 0x03])
    #expect(Data(framed.dropFirst(4)) == body)
  }

  @Test("frame of empty data is exactly the 4-byte zero prefix")
  internal func frameOfEmptyData() {
    let framed = HarvestMessageFraming.frame(Data())
    #expect(Array(framed) == [0x00, 0x00, 0x00, 0x00])
  }

  #if canImport(Darwin)
    /// Creates a connected pair of stream sockets for round-trip tests.
    private func makeSocketPair() throws -> (read: Int32, write: Int32) {
      var fds = [Int32](repeating: -1, count: 2)
      let result = socketpair(AF_UNIX, SOCK_STREAM, 0, &fds)
      try #require(result == 0, "socketpair failed: \(errno)")
      return (fds[0], fds[1])
    }

    @Test("writeMessage/readMessage round-trips a payload")
    internal func writeReadRoundTrip() throws {
      let pair = try makeSocketPair()
      defer {
        close(pair.read)
        close(pair.write)
      }

      let payload = Data("hello harvest".utf8)
      try HarvestMessageFraming.writeMessage(descriptor: pair.write, data: payload)
      let received = try HarvestMessageFraming.readMessage(
        descriptor: pair.read,
        maxLength: HarvestConfiguration.maxMessageLength
      )

      #expect(received == payload)
    }

    @Test("readMessage returns empty data for a zero-length body")
    internal func zeroLengthBodyRoundTrips() throws {
      let pair = try makeSocketPair()
      defer {
        close(pair.read)
        close(pair.write)
      }

      try HarvestMessageFraming.writeMessage(descriptor: pair.write, data: Data())
      let received = try HarvestMessageFraming.readMessage(
        descriptor: pair.read,
        maxLength: HarvestConfiguration.maxMessageLength
      )

      #expect(received.isEmpty)
    }

    @Test("readMessage rejects a body larger than maxLength")
    internal func oversizeBodyThrows() throws {
      let pair = try makeSocketPair()
      defer {
        close(pair.read)
        close(pair.write)
      }

      let payload = Data(repeating: 0x7F, count: 64)
      try HarvestMessageFraming.writeMessage(descriptor: pair.write, data: payload)

      #expect(throws: HarvestFramingError.messageTooLarge(length: 64, max: 16)) {
        _ = try HarvestMessageFraming.readMessage(descriptor: pair.read, maxLength: 16)
      }
    }

    @Test("readMessage throws connectionClosed on EOF before the prefix")
    internal func eofBeforePrefixThrows() throws {
      let pair = try makeSocketPair()
      // Close the writing end so the reader sees an immediate EOF.
      close(pair.write)
      defer { close(pair.read) }

      #expect(throws: HarvestFramingError.connectionClosed) {
        _ = try HarvestMessageFraming.readMessage(
          descriptor: pair.read,
          maxLength: HarvestConfiguration.maxMessageLength
        )
      }
    }

    @Test("readMessage throws connectionClosed on a truncated body")
    internal func truncatedBodyThrows() throws {
      let pair = try makeSocketPair()
      defer { close(pair.read) }

      // Announce a 10-byte body but send only 2 bytes, then close.
      var prefix = UInt32(10).bigEndian
      let prefixData = withUnsafeBytes(of: &prefix) { Data($0) }
      _ = prefixData.withUnsafeBytes { buffer in
        Darwin.write(pair.write, buffer.baseAddress, buffer.count)
      }
      _ = [UInt8]([0x01, 0x02]).withUnsafeBytes { buffer in
        Darwin.write(pair.write, buffer.baseAddress, buffer.count)
      }
      close(pair.write)

      #expect(throws: HarvestFramingError.connectionClosed) {
        _ = try HarvestMessageFraming.readMessage(
          descriptor: pair.read,
          maxLength: HarvestConfiguration.maxMessageLength
        )
      }
    }
  #endif
}
