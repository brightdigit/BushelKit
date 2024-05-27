//
// Service.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData) && canImport(XPC)
  import BushelCore
  import BushelData
  import BushelMessage
  import BushelMessageCore
  import Foundation
  import SwiftData
  @preconcurrency import XPC

  @available(macOS 14.0, *)
  @available(iOS, unavailable)
  public final class Service: ServiceInterface {
    internal struct NoDefinedMessageTypeError: Error {}

    public let database: any Database
    let messageTypes: [any Message.Type]
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var listener: XPCListener!

    internal init(database: any Database, messageTypes: [any Message.Type] = .all) {
      self.database = database
      self.messageTypes = messageTypes
    }

    internal convenience init(service: String, messageTypes: [any Message.Type] = .all) throws {
      let modelContainer: ModelContainer = .forTypes(.all)
      let database = BackgroundDatabase(modelContainer: modelContainer)

      self.init(database: database, messageTypes: messageTypes)

      let listener = try XPCListener(
        service: service,
        incomingSessionHandler: self.incomingSessionHandler
      )

      self.listener = listener
    }

    public static func launch(service: String) throws -> Never {
      _ = try Service(service: service)
      dispatchMain()
    }

    func performTask(with message: XPCReceivedMessage) -> (any (Encodable & Sendable))? {
      do {
        return try wait {
          try await self.perform(command: message)
        }
      } catch {
        print("Failed to decode received message, error: \(error)")
        return nil
      }
    }

    func incomingSessionHandler(
      _ request: XPCListener.IncomingSessionRequest
    ) -> XPCListener.IncomingSessionRequest.Decision {
      request.accept(incomingMessageHandler: self.performTask(with:))
    }

    func perform(command: any Command) async throws -> any (Encodable & Sendable) {
      var actual: (any Message)?
      var lastError: (any Error)?
      for messageType in self.messageTypes {
        do {
          let command = try command.decode(as: messageType)
          actual = command
          break
        } catch {
          lastError = error
        }
      }
      guard let actual else {
        if let lastError {
          throw lastError
        }
        throw NoDefinedMessageTypeError()
      }

      return try await actual.run(from: self)
    }
  }
#endif
