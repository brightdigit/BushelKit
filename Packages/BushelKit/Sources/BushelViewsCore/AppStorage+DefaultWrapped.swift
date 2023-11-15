//
// AppStorage+DefaultWrapped.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public extension AppStorage {
    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Bool,
      Value == Bool {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Int,
      Value == Int {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Double,
      Value == Double {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == String,
      Value == String {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == URL,
      Value == URL {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Data,
      Value == Data {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == Int {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }

    init<AppStoredType: DefaultWrapped>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value: RawRepresentable,
      Value.RawValue == String {
      self.init(
        wrappedValue: AppStoredType.default,
        type.key,
        store: store
      )
    }
  }
#endif
