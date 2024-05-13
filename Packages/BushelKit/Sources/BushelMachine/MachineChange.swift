//
//  MachineChange.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
        "property: \(change.property.rawValue)"
      case .guestDidStop:
        "guestDidStop"
      case .stopWithError:
        "stopWithError"
      case .networkDetatchedWithError:
        "networkDetatchedWithError"
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

extension MachineChange.PropertyChange {
  public init?(keyPath: String?, new: (any Sendable)? = nil, old: (any Sendable)? = nil) {
    guard let property = keyPath.flatMap(MachineChange.Property.init(rawValue:)) else {
      return nil
    }
    self.init(property: property, new: new, old: old)
  }
}
