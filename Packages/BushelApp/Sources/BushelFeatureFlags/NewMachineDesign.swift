//
// NewMachineDesign.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import FeatherQuill
  import SwiftUI

  public struct NewMachineDesign: BushelFeatureFlag {
    public typealias UserTypeValue = UserAudience

    public static let probability: Double = 0.25
    public static let initialValue = false
  }

  extension EnvironmentValues {
    public var newDesignFeature: NewMachineDesign.Feature { self[NewMachineDesign.self] }
  }
#endif
