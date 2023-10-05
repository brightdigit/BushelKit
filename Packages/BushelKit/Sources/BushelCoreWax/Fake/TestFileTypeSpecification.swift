//
// TestFileTypeSpecification.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public enum TestFileTypeSpecification: FileTypeSpecification {
  public static var fileType: FileType = .exportedAs(
    "com.brightdigit.test",
    "test"
  )
}
