//
// VZMachine+SnapshotMachine.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine

#if canImport(Virtualization) && arch(arm64)

  extension VZMachine {
    func beginSnapshot() -> SnapshotPaths {
      assert(url.startAccessingSecurityScopedResource())
      return .init(machinePathURL: url)
    }

    func finishedWithSnapshot(_ snapshot: BushelMachine.Snapshot, by difference: SnapshotDifference) {
      url.stopAccessingSecurityScopedResource()
      switch difference {
      case .append:
        self.configuration.snapshots.append(snapshot)

      case .remove:
        let index = self.configuration.snapshots.firstIndex { $0.id == snapshot.id }
        guard let index else {
          assertionFailure()
          return
        }
        self.configuration.snapshots.remove(at: index)

      case .restored:
        break

      case .export:
        break
      }
    }
  }
#endif
