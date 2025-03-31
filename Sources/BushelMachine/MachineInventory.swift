//
//  MachineInventory.swift
//  BushelKit
//
//  Created by Leo Dion on 3/31/25.
//

public import Observation
import Foundation

@Observable
public final class MachineInventory : Sendable  {
  
  struct MachineInfo {
    internal init(machine: any Machine, observationID: UUID, properties: MachineProperties? = nil) {
      self.machine = machine
      self.observationID = observationID
      self.properties = properties ?? .init(state: .stopped, canStart: false, canStop: false, canPause: false, canResume: false, canRequestStop: false)
    }
    
    let machine : any Machine
    let observationID : UUID
    var properties : MachineProperties
  }
  
  public init() {
    
  }
  
  @MainActor
  var registeredMachines : [UUID : MachineInfo] = [:]
  
  nonisolated func registerMachine(_ machine: any Machine, withID id: UUID) {
    let observationID = machine.beginObservation { [self] machineChange in
      self.machineWithID(id, updatedTo: machineChange)
    }
    Task { @MainActor in
      self.registeredMachines[id] = .init(machine: machine, observationID: observationID)
    }
  }
  
  nonisolated func machineWithID(_ id: UUID, updatedTo changes: MachineChange) {
    
  }
  
  
}
