//
// TestFileTypeSpecification+Fake.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

internal enum TestFileTypeSpecification: FileTypeSpecification {
  internal static var fileType: FileType = .exportedAs("com.brightdigit.test", "test")
}
