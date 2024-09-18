//
// CaptureSessionError.swift
// Copyright (c) 2024 BrightDigit.
//

public enum CaptureSessionError: Error {
  case videoInputNotReady
  case missingAttachments
  case missingMetrics
  case invalidAssetWriterStatus(Int)
  case missingPixelBuffer
  case pixelBufferError(CVPixelBufferError)
  case assetWriterFailure((any Error)?)
}
