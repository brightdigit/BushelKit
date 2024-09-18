//
// CVPixelBufferError.swift
// Copyright (c) 2024 BrightDigit.
//

public enum CVPixelBufferError: Error {
  case missingBaseAddress
  case allocationFailure
  case scalingFailure(Int)
  case conversionFailure(Int)
}
