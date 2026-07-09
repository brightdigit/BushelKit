//
//  HarvestMessageFraming.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

#if canImport(Darwin)
  import Darwin
#endif

/// Shared length-prefix message framing for Harvest socket communication.
///
/// Wire format: a 4-byte big-endian `UInt32` length prefix followed by the
/// message body. Both the host (`BushelHarvestHost`) and the guest
/// (`HarvestBinKit`) frame their command/response traffic with this helper so
/// the format lives in exactly one place.
public enum HarvestMessageFraming {
  /// Frames a message with a 4-byte big-endian length prefix.
  /// - Parameter data: The message body.
  /// - Returns: The length-prefixed framed data.
  public static func frame(_ data: Data) -> Data {
    var length = UInt32(data.count).bigEndian
    var framed = Data(capacity: data.count + 4)
    withUnsafeBytes(of: &length) { framed.append(contentsOf: $0) }
    framed.append(data)
    return framed
  }

  #if canImport(Darwin)
    /// Applies send and receive timeouts to a socket so blocking I/O cannot
    /// park indefinitely when the peer stops responding.
    /// - Parameters:
    ///   - descriptor: The socket file descriptor.
    ///   - seconds: The timeout in whole seconds.
    public static func configureTimeouts(descriptor: Int32, seconds: Int) {
      var timeoutValue = timeval(tv_sec: seconds, tv_usec: 0)
      let size = socklen_t(MemoryLayout<timeval>.size)
      _ = withUnsafePointer(to: &timeoutValue) {
        setsockopt(descriptor, SOL_SOCKET, SO_RCVTIMEO, $0, size)
      }
      _ = withUnsafePointer(to: &timeoutValue) {
        setsockopt(descriptor, SOL_SOCKET, SO_SNDTIMEO, $0, size)
      }
    }

    /// Frames `data` and writes it in full to the file descriptor.
    /// - Parameters:
    ///   - descriptor: The socket file descriptor.
    ///   - data: The message body to frame and send.
    /// - Throws: ``HarvestFramingError/posix(_:)`` if the write fails.
    public static func writeMessage(descriptor: Int32, data: Data) throws {
      let framed = frame(data)
      try framed.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
        guard let base = buffer.baseAddress else {
          return
        }
        var bytesWritten = 0
        while bytesWritten < buffer.count {
          let result = Darwin.write(descriptor, base + bytesWritten, buffer.count - bytesWritten)
          if result < 0 {
            // A signal-interrupted syscall is transient; retry rather than fail.
            if errno == EINTR {
              continue
            }
            throw HarvestFramingError.posix(POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO))
          }
          bytesWritten += result
        }
      }
    }

    /// Reads a single length-prefixed message from the file descriptor.
    /// - Parameters:
    ///   - descriptor: The socket file descriptor.
    ///   - maxLength: The largest body size to accept before failing.
    /// - Returns: The message body.
    /// - Throws: ``HarvestFramingError`` on EOF, oversized length, or I/O error.
    public static func readMessage(descriptor: Int32, maxLength: Int) throws -> Data {
      let lengthBytes = try readExactly(descriptor: descriptor, count: 4)
      let length = UInt32(
        bigEndian: lengthBytes.withUnsafeBytes { $0.loadUnaligned(as: UInt32.self) }
      )
      let bodyLength = Int(length)
      guard bodyLength <= maxLength else {
        throw HarvestFramingError.messageTooLarge(length: bodyLength, max: maxLength)
      }
      let body = try readExactly(descriptor: descriptor, count: bodyLength)
      return Data(body)
    }

    /// Reads exactly `count` bytes from a file descriptor, looping over partial reads.
    /// - Parameters:
    ///   - descriptor: The file descriptor to read from.
    ///   - count: The number of bytes to read (zero yields an empty result).
    /// - Returns: The bytes read.
    /// - Throws: ``HarvestFramingError/connectionClosed`` on EOF, or
    ///   ``HarvestFramingError/posix(_:)`` on read failure (including timeout).
    private static func readExactly(descriptor: Int32, count: Int) throws -> [UInt8] {
      var buffer = [UInt8](repeating: 0, count: count)
      try buffer.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
        guard let base = pointer.baseAddress else {
          return
        }
        var totalBytesRead = 0
        while totalBytesRead < count {
          let bytesRead = Darwin.read(descriptor, base + totalBytesRead, count - totalBytesRead)
          if bytesRead < 0 {
            // A signal-interrupted syscall is transient; retry rather than fail.
            if errno == EINTR {
              continue
            }
            throw HarvestFramingError.posix(POSIXError(POSIXErrorCode(rawValue: errno) ?? .EIO))
          } else if bytesRead == 0 {
            throw HarvestFramingError.connectionClosed
          }
          totalBytesRead += bytesRead
        }
      }
      return buffer
    }
  #endif
}
