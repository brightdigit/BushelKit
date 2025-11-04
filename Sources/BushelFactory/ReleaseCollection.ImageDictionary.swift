//
//  ReleaseCollection.ImageDictionary.swift
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

import BushelFoundation
import BushelMachine
import Foundation

extension ReleaseCollection.ImageDictionary {
  internal init(images: [any InstallerImage], uniqueOnly: Bool) {
    let newImages: [any InstallerImage]

    if uniqueOnly {
      newImages = images.removingDuplicates(groupingBy: { $0.buildIdentifier })
    } else {
      newImages = images
    }

    self.init(grouping: newImages) { image in
      image.operatingSystemVersion.majorVersion
    }
  }

  internal func sorted(byOrder order: SortOrder?) -> Self {
    guard let order else {
      return self
    }

    return self.mapValues { images in
      images.sorted { lhs, rhs in
        switch order {
        case .forward:
          lhs.operatingSystemVersion < rhs.operatingSystemVersion
        case .reverse:
          lhs.operatingSystemVersion > rhs.operatingSystemVersion
        }
      }
    }
  }
}

extension ReleaseCollection {
  internal typealias ImageDictionary = [Int: [any InstallerImage]]
}
