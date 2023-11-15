//
// AppStored.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum RecentDocumentsClearDate: AppStored {
  public typealias Value = Date?
}

public enum OnboardingAlphaAt: AppStored {
  public typealias Value = Date?
}

@available(*, unavailable, message: "Not ready for release.")
public enum OnboardingV1At: AppStored {
  public typealias Value = Date?
}

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

public enum Preference {
  public enum MachineShutdownAction: AppStored {
    public typealias Value = MachineShutdownActionOption?
    public static let keyType: KeyType = .reflecting
  }

  public enum SessionCloseButtonAction: AppStored {
    public typealias Value = SessionCloseButtonActionOption?
    public static let keyType: KeyType = .reflecting
  }
}

public enum KeyType {
  case describing
  case reflecting
}

public protocol DefaultWrapped: AppStored {
  static var `default`: Value { get }
}

public protocol AppStored {
  associatedtype Value
  static var keyType: KeyType { get }
  static var key: String { get }
}

public extension AppStored {
  static var key: String {
    switch self.keyType {
    case .describing:
      String(describing: Self.self)

    case .reflecting:
      String(reflecting: Self.self).components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
  }

  static var keyType: KeyType {
    .describing
  }
}
