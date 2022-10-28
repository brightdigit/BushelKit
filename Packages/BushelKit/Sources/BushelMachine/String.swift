//
// String.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public extension String {
  func prepending<T>(_ aString: T) -> String where T: StringProtocol {
    aString.appending(self)
  }
}
