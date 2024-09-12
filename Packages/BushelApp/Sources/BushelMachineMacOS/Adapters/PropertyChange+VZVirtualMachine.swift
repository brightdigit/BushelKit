//
// PropertyChange+VZVirtualMachine.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelMachine
  import Virtualization

  extension PropertyChange {
    static func observer<Value>(
      for keyPath: KeyPath<VZVirtualMachine, Value>,
      _ convert: @escaping @Sendable (Value) -> Self.ValueType?
    ) -> PropertyChangeObserving<Self, Value> {
      PropertyChangeObserving(keyPath: keyPath, conversion: convert)
    }

    static func observer(
      for keyPath: KeyPath<VZVirtualMachine, Self.ValueType>,
      _ convert: @escaping @Sendable (Self.ValueType) -> Self.ValueType? = { $0 }
    ) -> PropertyChangeObserving<Self, ValueType> {
      PropertyChangeObserving(keyPath: keyPath, conversion: convert)
    }
  }
#endif
