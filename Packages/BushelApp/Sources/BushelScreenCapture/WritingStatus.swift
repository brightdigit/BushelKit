//
// WritingStatus.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AVFoundation)
  import AVFoundation

  extension AVAssetWriter {
    enum WritingStatus {
      case invalid(Status)
      case starting
      case active
    }

    func verifyWriting(atSourceTime sourceTime: CMTime) -> WritingStatus {
      guard self.status == .writing || self.status == .unknown else {
        return .invalid(self.status)
      }

      if self.status == .unknown {
        self.startWriting()
        self.startSession(atSourceTime: sourceTime)
        return .starting
      }

      return .active
    }
  }
#endif
