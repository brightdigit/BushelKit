//
// NSError+VZInstallError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import Foundation
  import Virtualization

  extension NSError: VZInstallError {
    public var isVZError: Bool {
      self.domain == VZErrorDomain
    }

    public var rawCode: Int {
      self.code
    }

    public var underlyingError: VZUnderlyingError? {
      (self.userInfo[NSUnderlyingErrorKey] as? NSError).flatMap(VZUnderlyingNSError.init)
    }

    public func codeMatches(_ code: VZError.Code) -> Bool {
      self.code == code.rawValue
    }
  }
#endif
