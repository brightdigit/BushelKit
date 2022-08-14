//
// SessionView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
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

  @Published var session: MachineSession? {
    didSet {
      if var session = session {
        session.delegate = self
      }
    }
  }

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

struct SessionView: View {
  @StateObject var sessionManager = SessionObject()
  var body: some View {
    Group {
      switch (self.sessionManager.sessionStartResult, self.sessionManager.sessionResult) {
      case let (.success, .success(session)):
        session.view
      case let (.failure(error), _):
        Text(error.localizedDescription)
      case let (_, .failure(error)):
        Text(error.localizedDescription)

      case (_, .none):
        ProgressView {
          Text("Creating Session...")
        }

      case (.none, .some(.success)):
        ProgressView {
          Text("Starting Session...")
        }
      }
    }.onOpenURL { externalURL in
      self.sessionManager.externalURL = externalURL
      dump(externalURL)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SessionView()
  }
}
