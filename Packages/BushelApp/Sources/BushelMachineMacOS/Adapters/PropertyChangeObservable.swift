//
// PropertyChangeObservable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  internal protocol PropertyChangeObservable {
    associatedtype PropertyChangeType: PropertyChange
    associatedtype PropertyValue

    var keyPath: KeyPath<VZVirtualMachine, PropertyValue> { get }

    func converting(from value: PropertyValue) -> PropertyChangeType.ValueType?
  }
#endif
