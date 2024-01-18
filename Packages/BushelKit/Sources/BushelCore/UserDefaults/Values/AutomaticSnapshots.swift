//
// AutomaticSnapshots.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum AutomaticSnapshots {
  public enum Enabled: AppStored, DefaultWrapped {
    public typealias Value = Bool
    public static let keyType: KeyType = .reflecting
    public static let `default`: Bool = true
  }

  public enum Value: AppStored {
    public typealias Value = Int?
    public static let keyType: KeyType = .reflecting
  }

  public enum Polynomial: AppStored, DefaultWrapped {
    public typealias Value = LagrangePolynomial
    public static let keyType: KeyType = .reflecting
    public static let `default`: LagrangePolynomial = .default
  }
}
