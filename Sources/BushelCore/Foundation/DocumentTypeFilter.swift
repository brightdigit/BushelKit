//
//  DocumentTypeFilter.swift
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

import RadiantDocs

public struct DocumentTypeFilter: OptionSet, Sendable {
  public typealias RawValue = Int
  public static let libraries: DocumentTypeFilter = .init(rawValue: 1)

  public let rawValue: Int

  public init(rawValue: Int) { self.rawValue = rawValue }
}

extension DocumentTypeFilter {
  public var searchStrings: [String] {
    var pathExtensions = [String?]()
    if contains(.libraries) { pathExtensions.append(FileType.restoreImageLibrary.fileExtension) }
    return pathExtensions.compactMap { pathExtension in
      guard let pathExtension else { return nil }
      return ".\(pathExtension)"
    }
  }
}
