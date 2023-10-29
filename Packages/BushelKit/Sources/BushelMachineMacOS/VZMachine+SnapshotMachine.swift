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

    func updatedMetadata(forSnapshot snapshot: Snapshot, atIndex index: Int) {
      self.configuration.snapshots[index] = snapshot
    }

    #warning("logging-note: I think we should log every step here")
    func finishedWithSnapshot(_ snapshot: BushelMachine.Snapshot, by difference: SnapshotDifference) {
      url.stopAccessingSecurityScopedResource()
      switch difference {
      case .append:
        self.configuration.snapshots.append(snapshot)

      case .remove:
        let index = self.configuration.snapshots.firstIndex { $0.id == snapshot.id }
        guard let index else {
          #warning("logging-note: should we have descriptive failure instead?")
          assertionFailure()
          return
        }
        self.configuration.snapshots.remove(at: index)

        #warning("logging-note: any logging recommended for these two ignored cases?")

      case .restored:
        break

      case .export:
        break
      }
    }
  }
#endif
