//
// SessionObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine)

  import BushelMachine
  import Combine
  import Foundation
  class SessionObject: NSObject, ObservableObject, MachineSessionDelegate, LoggerCategorized {
    static var loggingCategory: LoggerCategory {
      .reactive
    }

    @Published var externalURL: URL?
    @Published var machineFileURL: URL?
    @Published var session: MachineSession?

    @Published var machineState: MachineState?
    @Published var machineAllowedStateActions = StateAction()

    @Published var lastError: Error?

    private var cancellables = [AnyCancellable]()

    func updateState(fromSession session: MachineSession?, withError error: Error?) {
      if let error = error {
        Self.logger.error("Session error: \(error.localizedDescription)")
      }
      DispatchQueue.main.async {
        self.machineState = session?.state
        self.machineAllowedStateActions = session?.allowedStateAction ?? .init()
        self.lastError = error
      }
    }

    func sessionDidStop(_ session: BushelMachine.MachineSession) {
      updateState(fromSession: session, withError: nil)
    }

    func session(_ session: BushelMachine.MachineSession, didStopWithError error: Error) {
      updateState(fromSession: session, withError: error)
    }

    func session(
      _ session: BushelMachine.MachineSession,
      device _: BushelMachine.MachineNetworkDevice,
      attachmentWasDisconnectedWithError error: Error
    ) {
      updateState(fromSession: session, withError: error)
    }

    func requestStop() {
      guard let session = session else {
        updateState(fromSession: nil, withError: MachineError.undefinedType("no session available", nil))
        return
      }
      do {
        try session.requestShutdown()
      } catch {
        updateState(fromSession: session, withError: error)
      }
    }

    func beginPause() {
      guard let session = session else {
        updateState(fromSession: nil, withError: MachineError.undefinedType("no session available", nil))
        return
      }
      Task {
        do {
          try await session.pause()
        } catch {
          self.updateState(fromSession: session, withError: error)
        }
      }
    }

    func beginResume() {
      guard let session = session else {
        updateState(fromSession: nil, withError: MachineError.undefinedType("no session available", nil))
        return
      }
      Task {
        do {
          try await session.resume()
        } catch {
          self.updateState(fromSession: session, withError: error)
        }
      }
    }

    func beginStop() {
      guard let session = session else {
        updateState(fromSession: nil, withError: MachineError.undefinedType("no session available", nil))
        return
      }
      Task {
        do {
          try await session.stop()
        } catch {
          self.updateState(fromSession: session, withError: error)
        }
      }
    }

    func beginStart() {
      guard let session = session else {
        updateState(fromSession: nil, withError: MachineError.undefinedType("no session available", nil))
        return
      }
      Task {
        do {
          try await session.begin()
        } catch {
          self.updateState(fromSession: session, withError: error)
        }
      }
    }

    func setupSession(_ session: MachineSession) {
      self.session = session
      session.delegate = self
      beginStart()
    }

    // swiftlint:disable:next function_body_length
    override init() {
      super.init()
      $externalURL.compactMap(\.?.relativePath).map(URL.init(fileURLWithPath:)).assign(to: &$machineFileURL)

      $machineFileURL.compactMap { $0 }

        .tryMap(Machine.init(loadFrom:))
        .tryCompactMap {
          try $0.createMachine()
        }
        .map(Result.success)
        .catch { error in
          Just(Result.failure(error))
        }
        .receive(on: DispatchQueue.main)
        .sink { result in
          switch result {
          case let .failure(error):
            self.updateState(fromSession: nil, withError: error)

          case let .success(session):
            self.setupSession(session)
          }
        }
        .store(in: &cancellables)
    }
  }
#endif
