//
// XPCSession.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(XPC)
  import BushelSession
  import BushelSessionCore
  import XPC

  @available(macOS 14.0, *)
  extension XPCSession: SessionService {
    public func cancel(reason: ServiceCancelReason) {
      self.cancel(reason: reason.rawValue)
    }

    public func sendMessage<Reply>(_ message: some Encodable) async throws -> Reply where Reply: Decodable {
      try await withCheckedThrowingContinuation { contuation in
        do {
          try self.send(message) { result in
            contuation.resume(with: result)
          }
        } catch {
          contuation.resume(throwing: error)
        }
      }
    }
  }
#endif
