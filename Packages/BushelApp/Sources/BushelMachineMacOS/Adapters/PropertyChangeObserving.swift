//
// PropertyChangeObserving.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  internal struct PropertyChangeObserving<
    PropertyChangeType: PropertyChange,
    PropertyValue
  >: PropertyChangeObservable {
    let keyPath: KeyPath<VZVirtualMachine, PropertyValue>
    let conversion: @Sendable (PropertyValue) -> PropertyChangeType.ValueType?

    func converting(from value: PropertyValue) -> PropertyChangeType.ValueType? {
      self.conversion(value)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == StatePropertyChange, PropertyValue == VZVirtualMachine.State {
    static func state() -> Self {
      StatePropertyChange.observer(for: \.state, MachineState.init)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == CanPausePropertyChange, PropertyValue == Bool {
    static func canPause() -> Self {
      CanPausePropertyChange.observer(for: \.canPause)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == CanStopPropertyChange, PropertyValue == Bool {
    static func canStop() -> Self {
      CanStopPropertyChange.observer(for: \.canStop)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == CanStartPropertyChange, PropertyValue == Bool {
    static func canStart() -> Self {
      CanStartPropertyChange.observer(for: \.canStart)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == CanResumePropertyChange, PropertyValue == Bool {
    static func canResume() -> Self {
      CanResumePropertyChange.observer(for: \.canResume)
    }
  }

  extension PropertyChangeObserving
    where PropertyChangeType == CanRequestStopPropertyChange, PropertyValue == Bool {
    static func canRequestStop() -> Self {
      CanRequestStopPropertyChange.observer(for: \.canRequestStop)
    }
  }
#endif
