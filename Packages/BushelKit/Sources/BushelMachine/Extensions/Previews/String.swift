//
// String.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension String {
  func prepending<T>(_ aString: T) -> String where T: StringProtocol {
    aString.appending(self)
  }
}
