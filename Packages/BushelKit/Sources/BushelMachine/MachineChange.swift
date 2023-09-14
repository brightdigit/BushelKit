//
// MachineChange.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#endif

public struct MachineChange {
  public enum Property: String {
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

  public struct PropertyChange: CustomStringConvertible {
    public var description: String {
      "\(property): \(String(describing: old)) -> \(String(describing: new))"
    }

    public init(property: Property, new: Any? = nil, old: Any? = nil) {
      self.property = property
      self.new = new
      self.old = old
    }

    public let property: Property
    public let new: Any?
    public let old: Any?
  }

  public enum Event {
    case property(PropertyChange)
    case guestDidStop
    case stopWithError(Error)
    case networkDetatchedWithError(Error)
  }

  public let event: Event
  public let source: any Machine
  public init(source: any Machine, event: MachineChange.Event) {
    self.event = event
    self.source = source
  }
}

public extension MachineChange.PropertyChange {
  init?(keyPath: String?, new: Any? = nil, old: Any? = nil) {
    guard let property = keyPath.flatMap(MachineChange.Property.init(rawValue:)) else {
      return nil
    }
    self.init(property: property, new: new, old: old)
  }
}
