//
// SessionKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMessageCore
  import BushelSessionCore
  import Foundation
  import SwiftData
  import SwiftUI

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

  public extension EnvironmentValues {
    var session: any Session {
      get { self[SessionKey.self] }
      set { self[SessionKey.self] = newValue }
    }
  }

  public extension Scene {
    func session(
      _ session: any Session
    ) -> some Scene {
      self.environment(\.session, session)
    }
  }

#endif
