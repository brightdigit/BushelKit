//
// SHA256.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Crypto
import Foundation

public struct SHA256: Codable, Hashable, CustomDebugStringConvertible {
  public init(digest: Data) {
    data = digest
  }

  public init(hashFromCompleteData data: Data) {
    let hash = CryptoSHA256.hash(data: data)
    let digest = Data(hash)
    self.init(digest: digest)
  }

  public init?(hexidecialString: String) {
    guard let data = hexidecialString.hexadecimal else {
      return nil
    }
    self.init(digest: data)
  }

  public init(fileURL: URL) async throws {
    let task = Task { () async throws -> Data in
      var hasher = CryptoSHA256()
      let handle = try FileHandle(forReadingFrom: fileURL)

      #if os(Linux)
        while let data = try handle.read(upToCount: CryptoSHA256.blockByteCount) {
          hasher.update(data: data)
        }
      #else
        while try autoreleasepool(invoking: {
          let data = try handle.read(upToCount: CryptoSHA256.blockByteCount)
          guard let data = data, !data.isEmpty else {
            return false
          }
          hasher.update(data: data)
          return true
        }) {}

      #endif
      let hash = hasher.finalize()
      return Data(hash)
    }

    try await self.init(digest: task.value)
  }

  let data: Data

  public var debugDescription: String {
    "SHA256(base64Encoded: \"\(data.base64EncodedString())\")!"
  }
}

public extension SHA256 {
  init?(base64Encoded: String) {
    guard let data = Data(base64Encoded: base64Encoded) else {
      return nil
    }
    self.init(digest: data)
  }
}
