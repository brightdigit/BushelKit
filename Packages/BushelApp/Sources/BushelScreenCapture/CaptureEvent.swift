//
// CaptureEvent.swift
// Copyright (c) 2024 BrightDigit.
//

public enum CaptureEvent: Sendable {
  case frame
  case active
  case error(CaptureSessionError)
}

extension CaptureEvent {
  init(didWriteResult: Result<Bool, CaptureSessionError>) {
    switch didWriteResult {
    case .success(true):
      self = .active
    case .success(false):
      self = .frame
    case let .failure(error):
      self = .error(error)
    }
  }

  init(_ didWrite: @escaping () throws(CaptureSessionError) -> Bool) {
    let didWriteResult = Result<Bool, CaptureSessionError>(catching: didWrite)
    self.init(didWriteResult: didWriteResult)
  }
}

extension CaptureEvent: CustomStringConvertible {
  public var description: String {
    switch self {
    case .frame:
      "Frame Completed."
    case .active:
      "Frame Writing."
    case let .error(error):
      "Frame Error: \(error.localizedDescription)"
    }
  }
}
