//
//  Tracking.swift
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

import Foundation

/// Provides types and values for tracking and analytics in the Radiant Kit.
public import RadiantKit

/// Represents different types of tracking-related errors.
public enum Tracking {
  /// Represents different types of tracking-related errors.
  public enum Error: DefaultWrapped {
    /// The key type used for this error type.
    public static let keyType: KeyType = .reflecting
    /// The value type associated with this error type.
    public typealias Value = Bool
    /// The default value for this error type.
    public static let `default`: Bool = true
  }

  /// Represents different types of analytics-related settings.
  public enum Analytics: DefaultWrapped {
    /// The key type used for this analytics type.
    public static let keyType: KeyType = .reflecting
    /// The value type associated with this analytics type.
    public typealias Value = Bool
    /// The default value for this analytics type.
    public static let `default`: Bool = true
  }
}
