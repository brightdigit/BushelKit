//
// AppStorage+AppStored.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  extension AppStorage {
    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Bool,
      Value == Bool {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Int,
      Value == Int {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Double,
      Value == Double {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == String,
      Value == String {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == URL,
      Value == URL {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Data,
      Value == Data {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == Int {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      wrappedValue: Value,
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == String {
      self.init(
        wrappedValue: wrappedValue,
        type.key,
        store: store
      )
    }
  }
#endif
