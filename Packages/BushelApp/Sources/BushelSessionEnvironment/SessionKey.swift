//
// SessionKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMessageCore

  public import BushelSessionCore
  import Foundation
  import SwiftData

  public import SwiftUI

  private struct DefaultSession: Session {
    private struct NotImplementatedError: Error {}

    // swiftlint:disable strict_fileprivate
    fileprivate static let instance: any Session = DefaultSession()

    fileprivate var isInitialized: Bool { false }

    fileprivate var isReady: Bool { false }

    fileprivate func sendMessage<MessageType>(
      _: MessageType
    ) async throws -> MessageType.ResponseType where MessageType: BushelMessageCore.Message {
      throw NotImplementatedError()
    }
    // swiftlint:enable strict_fileprivate
  }

  private struct SessionKey: EnvironmentKey {
    static var defaultValue: any Session {
      DefaultSession.instance
    }
  }

  extension EnvironmentValues {
    public var session: any Session {
      get { self[SessionKey.self] }
      set { self[SessionKey.self] = newValue }
    }
  }

  extension Scene {
    public func session(
      _ session: any Session
    ) -> some Scene {
      self.environment(\.session, session)
    }
  }

#endif
