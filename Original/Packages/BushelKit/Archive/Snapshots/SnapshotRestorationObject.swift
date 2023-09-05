//
// SnapshotRestorationObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine)
  import BushelMachine
  import BushelVirtualization
  import Combine
  import Foundation
  import HarvesterKit

  public class SnapshotRestorationObject: ObservableObject {
    @Published public private(set) var result: Result<URL, GlobalizedError>?

    let snapshotPathSubject = PassthroughSubject<SnapshotPath, Never>()

    public init() {
      Self.resultPublisherFrom(snapshotPathSubject: snapshotPathSubject).map {
        $0 as Result?
      }.assign(to: &$result)
    }

    static func resultPublisherFrom<SourcePublisher: Publisher>(
      snapshotPathSubject: SourcePublisher
    ) -> AnyPublisher<Result<URL, GlobalizedError>, Never>
      where SourcePublisher.Output == SnapshotPath, SourcePublisher.Failure == Never {
      let sharedSnapshotPathSubject = snapshotPathSubject
        .share()

      let machineResultPublisher = sharedSnapshotPathSubject
        .map(\.machinePath)
        .map(URL.init(fileURLWithPath:))
        .tryMap(Machine.init(loadFrom:))
        .mapResult()
        .share()

      let machineErrorResultPublisher = machineResultPublisher
        .compactMapOnlyFailure()
        .map(Result<URL, Error>.failure)

      let restorationResultPublisher = machineResultPublisher
        .compactMapOnlySuccess()
        .combineLatest(sharedSnapshotPathSubject.map(\.snapshotID))
        .map { machine, snapshotID in
          Future {
            var machine = machine
            return try await machine.restoreSnapshot(withID: snapshotID)
          }
        }
        .switchToLatest()
        .mapResult()
        .share()

      return restorationResultPublisher.merge(with: machineErrorResultPublisher)
        .map { result in
          result.mapError(GlobalizedError.init)
        }.eraseToAnyPublisher()
    }

    public func beginRestoring(_ snapshotPath: SnapshotPath) {
      snapshotPathSubject.send(snapshotPath)
    }
  }

#endif
