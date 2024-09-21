//
//  KVNSObservation.swift
//  Sublimation
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

#if canImport(ObjectiveC)
  import Foundation

  @available(*, deprecated) @MainActor final class KVNSObservation: KVObservation {
    let observed: NSObject
    let observer: NSObject
    let keyPaths: [String]

    init(observed: NSObject, observer: NSObject, keyPaths: [String]) {
      self.observed = observed
      self.observer = observer
      self.keyPaths = keyPaths
    }

    // swiftlint:disable line_length
    #warning(
      "logging-note: I wanted to note that I used to log every init while developing, just to make sure I am not leaving any leaks behind me, but not sure if this is useful for the current state of bushel development"
    )
    // swiftlint:enable line_length
    deinit {
      MainActor.assumeIsolated {
        for keyPath in keyPaths { observed.removeObserver(observer, forKeyPath: keyPath) }
      }
    }
  }
#endif