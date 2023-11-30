//
// MachineOperation.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelLocalization
import BushelMachine
import Foundation

struct MachineOperation: Identifiable, Equatable {
  enum OperationType {
    case restoring
    case exporting
    case saving
  }

  let id: UUID
  let label: String?
  let type: OperationType

  init(id: UUID, label: String?, type: OperationType) {
    self.id = id
    self.label = label
    self.type = type
  }
}

extension MachineOperation {
  var stringID: LocalizedStringID {
    switch self.type {
    case .exporting:
      .machineOperationSnapshotExporting

    case .restoring:
      .machineOperationSnapshotRestoring

    case .saving:
      .machineOperationSnapshotSaving
    }
  }

  static func restoringSnapshot(_ snapshot: Snapshot) -> MachineOperation {
    let name = snapshot.name.trimmingCharacters(in: .whitespacesAndNewlines)
    return self.init(id: snapshot.id, label: name.isEmpty ? nil : name, type: .restoring)
  }

  static func exportingSnapshot(_ snapshot: Snapshot) -> MachineOperation {
    let name = snapshot.name.trimmingCharacters(in: .whitespacesAndNewlines)
    return self.init(id: snapshot.id, label: name.isEmpty ? nil : name, type: .exporting)
  }

  static func savingSnapshot(_ request: SnapshotRequest) -> MachineOperation {
    let name = request.name.trimmingCharacters(in: .whitespacesAndNewlines)
    return self.init(id: UUID(), label: name.isEmpty ? "New Snapshot" : name, type: .saving)
  }
}
