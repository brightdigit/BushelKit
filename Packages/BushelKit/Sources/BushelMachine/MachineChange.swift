//
// MachineChange.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#endif

public struct MachineChange: Sendable {
  public enum Property: String, Sendable {
    case state
    case canStart
    case canStop
    case canPause
    case canResume
    case canRequestStop
    case consoleDevices
    case directorySharingDevices
    case graphicsDevices
    case memoryBalloonDevices
    case networkDevices
    case socketDevices
  }

  public struct PropertyChange: CustomStringConvertible, Sendable {
    public let property: Property
    public let new: (any Sendable)?
    public let old: (any Sendable)?

    public var description: String {
      "\(property): \(String(describing: old)) -> \(String(describing: new))"
    }

    public init(property: Property, new: (any Sendable)? = nil, old: (any Sendable)? = nil) {
      self.property = property
      self.new = new
      self.old = old
    }
  }

  public enum Event: Sendable, CustomStringConvertible {
    case property(PropertyChange)
    case guestDidStop
    case stopWithError(any Error)
    case networkDetatchedWithError(any Error)

    public var description: String {
      switch self {
      case let .property(change):
        return "property: \(change.property.rawValue)"
      case .guestDidStop:
        return "guestDidStop"
      case .stopWithError:
        return "stopWithError"
      case .networkDetatchedWithError:
        return "networkDetatchedWithError"
      }
    }
  }

  public let event: Event
  public let source: any Machine

  public init(source: any Machine, event: MachineChange.Event) {
    self.event = event
    self.source = source
  }
}

public extension MachineChange.PropertyChange {
  init?(keyPath: String?, new: (any Sendable)? = nil, old: (any Sendable)? = nil) {
    guard let property = keyPath.flatMap(MachineChange.Property.init(rawValue:)) else {
      return nil
    }
    self.init(property: property, new: new, old: old)
  }
}
