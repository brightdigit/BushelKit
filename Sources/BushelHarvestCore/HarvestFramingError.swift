//
// HarvestFramingError.swift
// Copyright (c) 2025 BrightDigit.
//

public import Foundation

/// Errors thrown by ``HarvestMessageFraming`` when reading or writing framed
/// messages over a socket file descriptor.
public enum HarvestFramingError: Error {
  /// The peer closed the connection before the expected bytes were read.
  case connectionClosed

  /// The framed length prefix exceeded ``HarvestConfiguration/maxMessageLength``.
  case messageTooLarge(length: Int, max: Int)

  /// An underlying POSIX `read`/`write` failure (including I/O timeouts).
  case posix(POSIXError)
}
