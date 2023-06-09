//
// ImageLocation.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum ImageLocation {
  case remote(URL)
  case file(FileAccessor)
}
