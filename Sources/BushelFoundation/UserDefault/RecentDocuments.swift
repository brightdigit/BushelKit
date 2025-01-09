//
//  RecentDocuments.swift
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

public import Foundation
public import RadiantKit

public enum RecentDocuments {
  /// Represents a type filter for recent documents.
  public enum TypeFilter: AppStored, DefaultWrapped {
    /// The value type for the type filter.
    public typealias Value = DocumentTypeFilter
    /// The key type for the type filter.
    public static let keyType: KeyType = .reflecting
    /// The default value for the type filter.
    public static let `default`: DocumentTypeFilter = .init()
  }

  /// Represents the clear date for recent documents.
  public enum ClearDate: AppStored {
    /// The value type for the clear date.
    public typealias Value = Date?
    /// The key type for the clear date.
    public static let keyType: KeyType = .reflecting
  }
}
