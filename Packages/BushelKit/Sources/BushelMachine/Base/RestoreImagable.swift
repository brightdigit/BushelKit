//
// RestoreImagable.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol RestoreImagable {
  var metadata: ImageMetadata { get }
  var location: ImageLocation { get }
}
