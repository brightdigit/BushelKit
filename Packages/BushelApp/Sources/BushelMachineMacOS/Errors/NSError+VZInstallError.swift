//
// NSError+VZInstallError.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import Foundation

  public import BushelMachine

  public import Virtualization

  extension NSError: @retroactive InstallFailureError {}
  extension NSError: VZInstallError {
    public var isVZError: Bool {
      self.domain == VZErrorDomain
    }

    public var rawCode: Int {
      self.code
    }

    public var underlyingError: (any VZUnderlyingError)? {
      (self.userInfo[NSUnderlyingErrorKey] as? NSError).flatMap(VZUnderlyingNSError.init)
    }

    public func codeMatches(_ code: VZError.Code) -> Bool {
      self.code == code.rawValue
    }
  }
#endif
