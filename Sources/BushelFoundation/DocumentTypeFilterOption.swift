//
//  DocumentTypeFilterOption.swift
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
internal import Foundation

/// An enumeration representing different options for filtering documents by type.
public enum DocumentTypeFilterOption: Int, CaseIterable, Identifiable, Localizable, Sendable {
  /// Filters documents to include only machine-type documents.
  case machinesOnly
  /// Filters documents to include both machine-type and library-type documents.
  case machinesAndLibraries

  /// A mapping of each case to its corresponding localized string identifier.
  public static let localizedStringIDMapping: [Self: String] = [
    .machinesOnly: "settingsFilterRecentDocumentsMachinesOnly",
    .machinesAndLibraries: "settingsFilterRecentDocumentsNone",
  ]

  /// The associated tag value for the case.
  public var tag: Int {
    self.rawValue
  }

  /// The unique identifier for the case.
  public var id: Int {
    self.rawValue
  }

  /// The document type filter associated with the case.
  public var typeFilter: DocumentTypeFilter {
    switch self {
    case .machinesAndLibraries:
      []
    case .machinesOnly:
      .libraries
    }
  }

  /// Initializes a `DocumentTypeFilterOption` instance from a given `DocumentTypeFilter`.
  /// - Parameter filter: The `DocumentTypeFilter` to use for initialization.
  public init(filter: DocumentTypeFilter) {
    self = filter.contains(.libraries) ? .machinesOnly : .machinesAndLibraries
  }
}
