//
// Command.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal protocol Command {
  /// Gets the Decodable value from this message
  ///
  /// - Parameters:
  ///    - type: The type of the value in the message
  ///
  /// - Throws: If the message data doesn't decode to the type,
  /// this method throws the appropriate `DecodingError` error
  ///
  /// - Returns: A value of the specified type if the message data decodes successfully.
  func decode<T>(as type: T.Type) throws -> T where T: Decodable
}

#if canImport(XPC)
  import XPC

  extension XPCReceivedMessage: Command {}
#endif
