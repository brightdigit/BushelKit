//
//  HarvestConfiguration.swift
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

/// Shared configuration constants for Harvest host-guest communication.
///
/// - Important: The framing layer (``HarvestMessageFraming``) provides neither
///   encryption nor authentication. Harvest traffic is expected to travel over
///   the host↔guest VirtioSocket, which is not reachable off-device. Do not bind
///   this protocol to a TCP socket exposed beyond loopback without first adding a
///   secure transport and enforcing ``HarvestAuthToken`` validation on the
///   receiving side, since privileged commands (SSH enable, shutdown/restart)
///   flow over this channel.
public enum HarvestConfiguration {
  /// Default port for Harvest communication.
  /// Used for VirtioSocket (UInt32) and TCP network connections (UInt16).
  public static let defaultPort: Int = 8_080

  /// Maximum allowed size, in bytes, for a single framed message body.
  ///
  /// The length-prefix framing reads an attacker/peer-controlled 4-byte length
  /// before allocating the body buffer. Capping it prevents a malformed or
  /// hostile peer from forcing an unbounded (multi-gigabyte) allocation.
  public static let maxMessageLength: Int = 16_777_216  // 16 MiB

  /// Socket-level send/receive timeout, in seconds, for Harvest I/O.
  ///
  /// Applied via `SO_RCVTIMEO`/`SO_SNDTIMEO` so a blocking `read`/`write`
  /// cannot park a serial I/O queue indefinitely when the peer stops responding.
  public static let ioTimeoutSeconds: Int = 30
}
