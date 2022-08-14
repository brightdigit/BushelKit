//
// RestoreImagable.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import Foundation

public protocol RestoreImagable {
  var metadata: ImageMetadata { get }
  var location: ImageLocation { get }
}
