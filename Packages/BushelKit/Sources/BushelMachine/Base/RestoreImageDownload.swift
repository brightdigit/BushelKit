//
// RestoreImageDownload.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum RestoreImageDownload {
  case file(URL)
  case library(URL, UUID)
}
