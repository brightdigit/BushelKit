//
// RestoreImagable.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@available(*, deprecated)
public protocol RestoreImagable {
  var metadata: ImageMetadata { get }
  var location: ImageLocation { get }
}
