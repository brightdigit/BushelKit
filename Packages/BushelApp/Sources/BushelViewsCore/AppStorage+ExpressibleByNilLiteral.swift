//
// AppStorage+ExpressibleByNilLiteral.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import Foundation

  public import SwiftUI

  extension AppStorage where Value: ExpressibleByNilLiteral {
    public init<AppStoredType: AppStored>(
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

    public init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == Int? {
      self.init(
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == Double? {
      self.init(
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == String? {
      self.init(
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
      for type: AppStoredType.Type,
      store: UserDefaults? = nil
    ) where AppStoredType.Value == Value,
      Value == URL? {
      self.init(
        type.key,
        store: store
      )
    }

    public init<AppStoredType: AppStored>(
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

  extension AppStorage {
    public init<AppStoredType: AppStored, R>(
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

    public init<AppStoredType: AppStored, R>(
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
