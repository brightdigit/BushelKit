//
// SessionObject.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Combine
import SwiftUI

class SessionObject: NSObject, ObservableObject, MachineSessionDelegate {
  @Published var externalURL: URL?
  @Published var machineFileURL: URL?
  @Published var sessionResult: Result<MachineSession, Error>?
  @Published var sessionStartResult: Result<Void, Error>?

  func sessionDidStop(_: BushelMachine.MachineSession) {}

  func session(_: BushelMachine.MachineSession, didStopWithError _: Error) {}

  func session(_: BushelMachine.MachineSession, device _: BushelMachine.MachineNetworkDevice, attachmentWasDisconnectedWithError _: Error) {}

  override init() {
    super.init()
    $externalURL.compactMap(\.?.relativePath).map(URL.init(fileURLWithPath:)).assign(to: &$machineFileURL)

    $machineFileURL.compactMap { $0 }.tryMap(Machine.loadFromURL(_:)).tryMap {
      try $0.createMachine()
    }.map { session in
      session.map(Result.success) ?? Result.failure(MachineError.undefinedType("no session", nil))
    }.catch { error in
      Just(Result.failure(error))
    }.assign(to: &$sessionResult)

    let sessionPublisher = $sessionResult.compactMap {
      try? $0?.get()
    }

    sessionPublisher.map { (session: MachineSession) in

      Future(operation: { () in

        try await session.begin()

      })
    }.switchToLatest().map { $0 as Optional }.receive(on: DispatchQueue.main).assign(to: &$sessionStartResult)
  }
}
