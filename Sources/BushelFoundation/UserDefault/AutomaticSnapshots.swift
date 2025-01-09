//
//  AutomaticSnapshots.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import BushelUtilities
import Foundation
public import RadiantKit

/// Represents automatic snapshots settings.
public enum AutomaticSnapshots {
  /// Represents whether automatic snapshots are enabled.
  public enum Enabled: AppStored, DefaultWrapped {
    /// The type of the value.
    public typealias Value = Bool
    /// The key type used for storing the value.
    public static let keyType: KeyType = .reflecting
    /// The default value for automatic snapshots.
    public static let `default`: Bool = true
  }

  /// Represents the value of automatic snapshots.
  public enum Value: AppStored {
    /// The type of the value.
    public typealias Value = Int?
    /// The key type used for storing the value.
    public static let keyType: KeyType = .reflecting
  }

  /// Represents the polynomial used for automatic snapshots.
  public enum Polynomial: AppStored, DefaultWrapped {
    /// The type of the value.
    public typealias Value = LagrangePolynomial
    /// The key type used for storing the value.
    public static let keyType: KeyType = .reflecting
    /// The default value for the polynomial.
    public static let `default`: LagrangePolynomial = .default
  }
}
