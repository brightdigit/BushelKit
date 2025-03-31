//
//  MachineInventory.swift
//  BushelKit
//
//  Created by Leo Dion on 3/31/25.
//

public import Observation
import Foundation

extension MachineProperties {
  init (original: MachineProperties, propertyChange: any PropertyChange) {
    let type = type(of: propertyChange)
    
    var state : MachineState = original.state
    var canStart : Bool = original.canStart
    var canStop : Bool = original.canStop
    var canPause : Bool = original.canPause
    var canResume = original.canResume
    var canRequestStop = original.canRequestStop
    
    switch type.property {
    case .state:
      state = propertyChange.getValue() ?? state
    case .canStart:
      canStart = propertyChange.getValue() ?? canStart
    case .canStop:
      canStop = propertyChange.getValue() ?? canStop
    case .canPause:
      canPause = propertyChange.getValue() ?? canPause
    case .canResume:
      canResume = propertyChange.getValue() ?? canResume
    case .canRequestStop:
      canRequestStop = propertyChange.getValue() ?? canRequestStop
    }
    self.init(
      state: state,
      canStart: canStart,
      canStop: canStop,
      canPause: canPause,
      canResume: canResume,
      canRequestStop: canRequestStop
    )
  }
  func updateProperty(_ property: any PropertyChange) -> MachineProperties {
    .init(original: self, propertyChange: property)
  }
}

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
    
    mutating func updatedProperties(from changes: MachineChange) {
      if let properties = changes.properties {
        self.properties = properties
      }
      
      if case let .property(property) = changes.event {
        self.properties = self.properties.updateProperty(property)
      }
    }
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
    Task { @MainActor in
      self.onMachine(withID: id, updatedTo: changes)
    }
  }
  
  @MainActor
  func onMachine(withID id: UUID, updatedTo changes: MachineChange) {
    assert(self.registeredMachines[id] != nil)
    self.registeredMachines[id]?.updatedProperties(from: changes)
  }
  
}
