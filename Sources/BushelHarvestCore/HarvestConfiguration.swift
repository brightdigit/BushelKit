//
// HarvestConfiguration.swift
// Copyright (c) 2025 BrightDigit.
//

/// Shared configuration constants for Harvest host-guest communication
public enum HarvestConfiguration {
  /// Default port for Harvest communication.
  /// Used for VirtioSocket (UInt32) and TCP network connections (UInt16).
  public static let defaultPort: Int = 8080

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
