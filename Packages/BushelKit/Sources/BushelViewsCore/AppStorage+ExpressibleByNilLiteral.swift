//
// AppStorage+ExpressibleByNilLiteral.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public extension AppStorage where Value: ExpressibleByNilLiteral {
    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      // swiftlint:disable:next discouraged_optional_boolean
      Value == Bool? {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == Int? {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == Double? {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == String? {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == URL? {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == Data? {
      self.init(
        type.key,
        store: store
      )
    }
  }

  public extension AppStorage {
    init<AppStoredType: AppStored, R>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == R?,
      R: RawRepresentable,
      Value == AppStoredType.Value,
      R.RawValue == String {
      self.init(
        type.key,
        store: store
      )
    }

    init<AppStoredType: AppStored, R>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == R?,
      R: RawRepresentable,
      Value == AppStoredType.Value,
      R.RawValue == Int {
      self.init(
        type.key,
        store: store
      )
    }
  }
#endif
