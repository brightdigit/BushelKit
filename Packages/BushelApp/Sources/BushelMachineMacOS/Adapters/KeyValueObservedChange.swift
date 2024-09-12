//
// KeyValueObservedChange.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(ObjectiveC)

  import BushelMachine
  import Foundation

  internal struct KeyValueObservedChange<ValueType: Sendable>: ObservedChange {
    let oldValue: ValueType?

    let newValue: ValueType?
    internal init(oldValue: ValueType?, newValue: ValueType?) {
      self.oldValue = oldValue
      self.newValue = newValue
    }

    internal init<T>(oldValue: T?, newValue: T?, _ closure: @escaping @Sendable (T) -> ValueType?) {
      self.oldValue = oldValue.flatMap(closure)
      self.newValue = newValue.flatMap(closure)
    }

    init(change: NSKeyValueObservedChange<ValueType>) {
      self.init(oldValue: change.oldValue, newValue: change.newValue)
    }

    init<T>(change: NSKeyValueObservedChange<T>, _ closure: @escaping @Sendable (T) -> ValueType?) {
      self.init(oldValue: change.oldValue, newValue: change.newValue, closure)
    }
  }
#endif
